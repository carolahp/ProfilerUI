Extension { #name : #AndreasSystemProfiler }

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler class >> newProfilerUI [ 
	^ ProfilerUIAndreas new
		profiler: self new;
		yourself
]

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler >> tallyRoot [
	^ tallyRoot
]

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler >> totalTime [
	^ totalTime
]
