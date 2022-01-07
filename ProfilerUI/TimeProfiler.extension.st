Extension { #name : #TimeProfiler }

{ #category : #'*ProfilerUI' }
TimeProfiler class >> newProfilerUI [ 
	^ ProfilerUI new
		profiler: self new;
		yourself
]
