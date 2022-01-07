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

	^ profiler ifNil: [ profiler := profiler ]
]

{ #category : #accessing }
ProfilerUI >> profiler: anObject [

	profiler := anObject
]

{ #category : #accessing }
ProfilerUI >> rootTallyItems [
	^ self profiler rootTallyItems
]

{ #category : #profiling }
ProfilerUI >> startProfiling [
	^ self profiler startProfiling
]

{ #category : #profiling }
ProfilerUI >> stopProfiling [
	^ self profiler stopProfiling
]
