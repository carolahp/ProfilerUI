"
I am an abstract adapter for profilers to be used by the ProfilerPresenter
"
Class {
	#name : #ProfilerModel,
	#superclass : #Object,
	#instVars : [
		'profiler',
		'threshold',
		'tallyRoot'
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

{ #category : #'accessing tree' }
ProfilerModel >> leaveItems [
	| res  |
	res := OrderedCollection new.
	self tallyRoot 
		ifNotNil: [ 
			| dict |
			dict := IdentityDictionary new: 100.
			self tallyRoot leavesInto: dict fromSender: nil.
			res addAll: (dict asOrderedCollection sort reverse)].
	^ res
]

{ #category : #'accessing tree' }
ProfilerModel >> leaveItemsOver: perCent [

	| leaveThreshold |
	leaveThreshold := (perCent asFloat / 100 * self tallyRoot tally) rounded.
	^ self leaveItems select: [ :item | item tally > leaveThreshold ]
]

{ #category : #accessing }
ProfilerModel >> profiler: anObject [

	profiler := anObject
]

{ #category : #'accessing tree' }
ProfilerModel >> rootTallyItems [

	^ self rootTallyItemsOver: 0
]

{ #category : #'accessing tree' }
ProfilerModel >> rootTallyItemsOver: perCent [
	^ (self tallyRoot sonsOver: perCent) 
		ifEmpty: [ #() ]
		ifNotEmpty: [:sons | sons asOrderedCollection sort reverse ] 
]

{ #category : #profiling }
ProfilerModel >> startProfiling [
	self subclassResponsibility 
]

{ #category : #profiling }
ProfilerModel >> stopProfiling [
	self subclassResponsibility 
]

{ #category : #private }
ProfilerModel >> tallyRoot [

	^ tallyRoot ifNil: [ 
		  tallyRoot := profiler tallyRoot asTallyModel
			               profilerModel: self;
			               yourself ]
]

{ #category : #private }
ProfilerModel >> tallyRoot: aTallyObject [

	tallyRoot := aTallyObject asTallyModel
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
	^ profiler tallyRoot tally
]

{ #category : #accessing }
ProfilerModel >> totalTime [
	^ profiler totalTime
]
