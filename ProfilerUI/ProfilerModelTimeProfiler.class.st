"
I am an adapter for the SystemProfiler to be used by the ProfilerPresenter
"
Class {
	#name : #ProfilerModelTimeProfiler,
	#superclass : #ProfilerModel,
	#category : #'ProfilerUI-Model'
}

{ #category : #profiling }
ProfilerModelTimeProfiler >> startProfiling [
	^ self shouldBeImplemented
]

{ #category : #profiling }
ProfilerModelTimeProfiler >> stopProfiling [
	^ self shouldBeImplemented
]
