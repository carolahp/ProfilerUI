"
I am an abstract adapter for profilers to be used by the ProfilerPresenter
"
Class {
	#name : #ProfilerModel,
	#superclass : #Object,
	#instVars : [
		'profiler',
		'threshold',
		'minTime'
	],
	#category : #'ProfilerUI-Model'
}

{ #category : #profiling }
ProfilerModel >> doReport [ 
	^ profiler doReport
]

{ #category : #accessing }
ProfilerModel >> minTime [
	^ minTime
]

{ #category : #accessing }
ProfilerModel >> minTime: aFloat [
	minTime := aFloat
]

{ #category : #accessing }
ProfilerModel >> profiler: anObject [

	profiler := anObject
]

{ #category : #accessing }
ProfilerModel >> rootTallyItems [
	^ profiler rootTallyItems
]

{ #category : #profiling }
ProfilerModel >> startProfiling [
	self subclassResponsibility 
]

{ #category : #profiling }
ProfilerModel >> stopProfiling [
	self subclassResponsibility 
]

{ #category : #accessing }
ProfilerModel >> tallyRoot [ 
	^ profiler tallyRoot asTallyModel profilerModel: self; yourself
]

{ #category : #accessing }
ProfilerModel >> threshold [
	^ threshold
]

{ #category : #accessing }
ProfilerModel >> threshold: aNumber [
	threshold := aNumber
]

{ #category : #accessing }
ProfilerModel >> total [
	^ self tallyRoot tally
]

{ #category : #accessing }
ProfilerModel >> totalTally [
	^ profiler totalTally
]

{ #category : #accessing }
ProfilerModel >> totalTime [
	^ profiler totalTime
]
