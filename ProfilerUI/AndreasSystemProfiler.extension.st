Extension { #name : #AndreasSystemProfiler }

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler class >> newProfilerModel [ 
	^ ProfilerModelAndreas new
		profiler: self new;
		yourself
]

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler >> tallyRoot [
	^ tallyRoot
]

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler >> totalTally [
	^ totalTally
]

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler >> totalTime [
	^ totalTime
]
