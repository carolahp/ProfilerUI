"
I am an abstract adapter for profilers to be used by the ProfilerPresenter
"
Class {
	#name : #ProfilerUI,
	#superclass : #Object,
	#instVars : [
		'profiler',
		'threshold',
		'minTime'
	],
	#category : #ProfilerUI
}

{ #category : #profiling }
ProfilerUI >> doReport [ 
	^ profiler doReport
]

{ #category : #accessing }
ProfilerUI >> minTime [
	^ minTime
]

{ #category : #accessing }
ProfilerUI >> minTime: aFloat [
	minTime := aFloat
]

{ #category : #accessing }
ProfilerUI >> profiler: anObject [

	profiler := anObject
]

{ #category : #accessing }
ProfilerUI >> rootTallyItems [

	^ (self tallyRoot sonsOver: self threshold) collect: [ :each | 
		  each asTallyUI profilerUI: self ]
]

{ #category : #profiling }
ProfilerUI >> startProfiling [
	^ profiler startProfiling
]

{ #category : #profiling }
ProfilerUI >> stopProfiling [
	^ profiler stopProfiling
]

{ #category : #accessing }
ProfilerUI >> tallyRoot [ 
	^ profiler tallyRoot
]

{ #category : #accessing }
ProfilerUI >> threshold [
	^ threshold
]

{ #category : #accessing }
ProfilerUI >> threshold: aNumber [
	threshold := aNumber
]

{ #category : #accessing }
ProfilerUI >> total [
	^ self tallyRoot tally
]

{ #category : #accessing }
ProfilerUI >> totalTime [
	^ profiler totalTime
]
