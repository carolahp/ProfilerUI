"
I am an abstract adapter for profilers to be used by the ProfilerPresenter
"
Class {
	#name : #ProfilerModel,
	#superclass : #Object,
	#instVars : [
		'profiler',
		'threshold'
	],
	#category : #'ProfilerUI-Model'
}

{ #category : #report }
ProfilerModel >> doReport [
	self threshold >= 0 ifFalse: [ 
		self error: 'Time threshold must be greater than 0' ].

	^ String streamContents: [ :s | 
		profiler report: s cutoff: self threshold / 100 ]
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
	"Minimum percentage of total time a node has to have to be created.
	It is a number between 0 and 100"
	^ threshold ifNil: [ threshold := 1 ]
]

{ #category : #accessing }
ProfilerModel >> threshold: aNumber [
	"minimum percentage of total time a node has to have to be created.
	aNumber must be between 0 and 1"
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
