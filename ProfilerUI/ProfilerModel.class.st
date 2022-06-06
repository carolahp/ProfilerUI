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
	self threshold < 0 ifTrue: [ 
		self error: 'Time threshold cannot be negative' ].

	^ String streamContents: [ :s | 
		profiler report: s cutoff: self threshold ]
]

{ #category : #accessing }
ProfilerModel >> profiler: anObject [

	profiler := anObject
]

{ #category : #accessing }
ProfilerModel >> rootTallyItems [

	^ self rootTallyItemsOver: 0
]

{ #category : #'accessing roots' }
ProfilerModel >> rootTallyItemsOver: perCent [
	^ ((self tallyRoot sonsOver: perCent) first sonsOver: perCent)
		  asOrderedCollection sort reverse
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

	^ profiler tallyRoot asTallyModel
		  profilerModel: self;
		  yourself
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
	aNumber must be between 0 and 100"
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
