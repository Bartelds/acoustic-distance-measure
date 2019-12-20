total_textgrids = numberOfSelected("TextGrid")
for i to total_textgrids
  textgrid[i] = selected(i)
endfor

for i to total_textgrids
  	selectObject: textgrid[i]
	textgrid$ = selected$ ("TextGrid")
	numberOfIntervals = Get number of intervals: 2
	
	for intervalNumber from 1 to numberOfIntervals
    	startTime = Get start point: 2, intervalNumber
    	endTime = Get end point: 2, intervalNumber
    	text$ = Get label of interval: 2, intervalNumber
    	appendFileLine: "~/" + textgrid$ + ".txt", intervalNumber, tab$, text$, tab$, startTime, tab$, endTime
	endfor
endfor