Extension { #name : #AndreasSystemProfiler }

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler class >> newProfilerUI [ 
	^ ProfilerUIAndreas new
		profiler: self new;
		yourself
]

{ #category : #'*ProfilerUI' }
AndreasSystemProfiler >> rootTallyItems [
	^ tallyRoot sonsOver: 0 
]
