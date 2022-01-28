"
I am an adapter for the AndreasProfiler to be used by the ProfilerPresenter
"
Class {
	#name : #ProfilerModelAndreas,
	#superclass : #ProfilerModel,
	#category : #'ProfilerUI-Model'
}

{ #category : #accessing }
ProfilerModelAndreas >> rootTallyItems [
	^ self tallyRoot sons
]

{ #category : #profiling }
ProfilerModelAndreas >> startProfiling [
	^ profiler startProfiling
]

{ #category : #profiling }
ProfilerModelAndreas >> stopProfiling [
	^ profiler stopProfiling
]
