"
I am an abstract adapter for profilers to be used by the ProfilerPresenter
"
Class {
	#name : #ProfilerUI,
	#superclass : #Object,
	#instVars : [
		'profiler'
	],
	#category : #ProfilerUI
}

{ #category : #accessing }
ProfilerUI >> profiler [

	^ profiler ifNil: [ self error: 'profiler is nil' ]
]

{ #category : #accessing }
ProfilerUI >> profiler: anObject [

	profiler := anObject
]

{ #category : #accessing }
ProfilerUI >> rootTallyItems [

	^ self profiler rootTallyItems collect: #asTallyUI
]

{ #category : #profiling }
ProfilerUI >> startProfiling [
	^ self profiler startProfiling
]

{ #category : #profiling }
ProfilerUI >> stopProfiling [
	^ self profiler stopProfiling
]
