library(dtw, dplyr)

corpusdir = ""
accent_data <- read.table("./", header=TRUE, sep=" ")
reference_speaker <- read.table("./", header=TRUE, sep=" ")

distance <- function(audio){
  words = c("ALSO", "AND", "AND1", "AND2", "ASK", "AT", "BAGS", "BIG", "BLUE", "BOB", "BRING", "BROTHER", "CALL", "CAN", "CHEESE",
            "FIVE", "FOR", "FOR1", "FRESH", "FROG", "FROM", "GO", "HER", "HER1", "HER2", "HER3", "INTO", "KIDS", "MAYBE", "MEET", "NEED",
            "OF", "OF1", "PEAS", "PLASTIC", "PLEASE", "RED", "SCOOP", "SHE", "SIX", "SLABS", "SMALL", "SNACK", "SNAKE", "SNOW",
            "SPOONS", "STATION", "STELLA", "STORE", "THE", "THE1", "THE2", "THESE", "THESE1", "THICK", "THINGS", "THINGS1",
            "THREE", "TO", "TOY", "TRAIN", "WE", "WE1" ,"WEDNESDAY", "WILL", "WITH")
  ds_all <- mapply(function(word) {
    f1 <- get(paste0(testsample, word,".s"))
    ds_word <- mapply(function(s2) {
      dobj <- dtw(f1, get(paste0(s2, word, ".s")), window.type="slantedband", window.size=200)
      return(dobj$normalizedDistance)
    }, referencelist$reference)
    return(mean(ds_word[ds_word!=0]))
  }, words)
  return(mean(ds_all[ds_all!=0]))
}

find_dist <- function(mfccs, dfunc = distance, mvn=TRUE) {
  for(id in accent_data$id) {
    feats <- read.table(paste0(corpusdir, mfccs, "/", id, ".", tolower(substr(mfccs,1,3)), "x"))
    if (mvn) {
      feats <- scale(feats)
    }
    assign(paste0(id, ".s"), feats, envir=globalenv())
  }
  
  for(id in reference_speaker$reference) {
    feats <- read.table(paste0(corpusdir, mfccs, "/", id, ".", tolower(substr(mfccs,1,3)), "x"))
    if (mvn) {
      feats <- scale(feats)
    }
    assign(paste0(id, ".s"), feats, envir=globalenv())
  }
  return(mapply(dfunc, accent_data$id))
}


find_dist <- function(mfccs, dfunc = distance, mvn=TRUE) {
  words = c("ALSO", "AND", "AND1", "AND2", "ASK", "AT", "BAGS", "BIG", "BLUE", "BOB", "BRING", "BROTHER", "CALL", "CAN", "CHEESE",
            "FIVE", "FOR", "FOR1", "FRESH", "FROG", "FROM", "GO", "HER", "HER1", "HER2", "HER3", "INTO", "KIDS", "MAYBE", "MEET", "NEED",
            "OF", "OF1", "PEAS", "PLASTIC", "PLEASE", "RED", "SCOOP", "SHE", "SIX", "SLABS", "SMALL", "SNACK", "SNAKE", "SNOW",
            "SPOONS", "STATION", "STELLA", "STORE", "THE", "THE1", "THE2", "THESE", "THESE1", "THICK", "THINGS", "THINGS1",
            "THREE", "TO", "TOY", "TRAIN", "WE", "WE1" ,"WEDNESDAY", "WILL", "WITH")
  for(id in accentdata$id) {
    speakerlist = list ()
    for(word in words) {
      feats <- read.table(paste0(corpusdir, mfccs, "/", id, "_" , word, ".", tolower(substr(mfccs,1,3)), "x"))
      feats$word <- word
      speakerlist[[word]] <- feats
    }
    per_speaker <- do.call(rbind, speakerlist)
    words <- per_speaker$word
    per_speaker <- scale(per_speaker[,-40])
    per_speaker <- as.data.frame(per_speaker)
    per_speaker$word <- words
    for(word in words) {
      assign(paste0(id, word, ".s"), per_speaker[per_speaker$word %in% word, -40], envir=globalenv())
    }
  }
  
  for(id in referencelist$reference) {
    speakerlist = list ()
    for(word in words) {
      feats <- read.table(paste0(corpusdir, mfccs, "/", id, "_" , word, ".", tolower(substr(mfccs,1,3)), "x"))
      feats$word <- word
      speakerlist[[word]] <- feats
    }
    per_speaker <- do.call(rbind, speakerlist)
    words <- per_speaker$word
    per_speaker <- scale(per_speaker[,-40])
    per_speaker <- as.data.frame(per_speaker)
    per_speaker$word <- words
    for(word in words) {
      assign(paste0(id, word, ".s"), per_speaker[per_speaker$word %in% word, -40], envir=globalenv())
    }
  }
  return(mapply(dfunc, accentdata$id))
}

accent_data$mfcc.mvn.plain <- find_dist("mfcc",dfunc=distance,mvn=TRUE)
write.table(accent_data, paste0('dtwdistances','.csv'),row.names = FALSE)