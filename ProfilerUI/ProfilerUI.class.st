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
	^ profiler rootTallyItems
]

{ #category : #profiling }
ProfilerUI >> startProfiling [
	self subclassResponsibility 
]

{ #category : #profiling }
ProfilerUI >> stopProfiling [
	self subclassResponsibility 
]

{ #category : #accessing }
ProfilerUI >> tallyRoot [ 
	^ profiler tallyRoot asTallyUI profilerUI: self; yourself
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
