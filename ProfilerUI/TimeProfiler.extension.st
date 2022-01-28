Extension { #name : #TimeProfiler }

{ #category : #'*ProfilerUI' }
TimeProfiler class >> newProfilerModel [ 
	^ ProfilerModel new
		profiler: self new;
		yourself
]
