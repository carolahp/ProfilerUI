Extension { #name : #AndreasSystemProfiler }

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler class >> newProfilerUI [ 
	^ ProfilerUIAndreas newFrom: self new
]

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler >> rootTallyItems [
	^ tallyRoot sonsOver: 0 
]
