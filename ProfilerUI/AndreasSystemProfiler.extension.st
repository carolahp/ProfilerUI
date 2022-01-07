Extension { #name : #AndreasSystemProfiler }

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler class >> newProfilerUI [ 
	^ ProfilerUIAndreas newFrom: self new
]

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler >> tallyRoot [
	^ tallyRoot
]

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler >> totalTime [
	^ totalTime
]
