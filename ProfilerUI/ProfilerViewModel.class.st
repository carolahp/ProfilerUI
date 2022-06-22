"
I am a controller used by the ProfilerPresenter to interact with different kinds of profiler models
"
Class {
	#name : #ProfilerViewModel,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'profilerModel',
		'code',
		'profilerClass',
		'profileAllProcesses',
		'showLeavesOnly',
		'profilerThreshold',
		'showNodeThreshold'
	],
	#category : #'ProfilerUI-ViewModel'
}

{ #category : #constants }
ProfilerViewModel >> allProfilerClasses [

	^ { AndreasSystemProfiler . TimeProfiler ". PreciseProfiler" }
]

{ #category : #accessing }
ProfilerViewModel >> announcer [ 
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
ProfilerViewModel >> code [
	^ code
]

{ #category : #accessing }
ProfilerViewModel >> code: aString [ 
	code := aString
]

{ #category : #constants }
ProfilerViewModel >> doItSelectorsPath [
	^ #( 'newProcess' 'runBlockAndProfile:' 'ensure:' 'DoIt' 'DoIt' )
]

{ #category : #constants }
ProfilerViewModel >> doItSourceCode [
	^ 'self runBlockAndProfile: [self profilerModel startProfiling. [' , self code,'] value ]'
]

{ #category : #api }
ProfilerViewModel >> hideNodesUnder: aNumber [
	"minimum percentage a node must have to be shown"
	showNodeThreshold := aNumber
]

{ #category : #initialization }
ProfilerViewModel >> initialize [ 
	super initialize.
	showLeavesOnly := false.
	showNodeThreshold := 0.
	profileAllProcesses := true.
	code := '10000 factorial'
]

{ #category : #'accessing nodes' }
ProfilerViewModel >> leaveItems [
	^ profilerModel leaveItems
]

{ #category : #'accessing nodes' }
ProfilerViewModel >> leaveItemsOver: perCent [
	^ profilerModel leaveItemsOver: perCent
]

{ #category : #private }
ProfilerViewModel >> newProfilerModel [

	^ profilerModel := self profilerClass newProfilerModel
]

{ #category : #accessing }
ProfilerViewModel >> profileAllProcesses [
	^ profileAllProcesses
]

{ #category : #accessing }
ProfilerViewModel >> profileAllProcesses: aBoolean [
	profileAllProcesses := aBoolean
]

{ #category : #accessing }
ProfilerViewModel >> profilerClass [
	^ profilerClass ifNil: [ profilerClass := self allProfilerClasses at: 1 ]
]

{ #category : #accessing }
ProfilerViewModel >> profilerClass: aClass [
	profilerClass := aClass
]

{ #category : #accessing }
ProfilerViewModel >> profilerModel [

	^ profilerModel
]

{ #category : #accessing }
ProfilerViewModel >> profilerThreshold: aFloat [

	profilerThreshold := aFloat
]

{ #category : #accessing }
ProfilerViewModel >> rootItems [

	^ showLeavesOnly
		  ifTrue: [ self leaveItemsOver: showNodeThreshold ]
		  ifFalse: [ self rootTallyItemsOver: showNodeThreshold ]
]

{ #category : #'accessing nodes' }
ProfilerViewModel >> rootTallyItems [

	^ self rootTallyItemsOver: 0
]

{ #category : #'accessing nodes' }
ProfilerViewModel >> rootTallyItemsOver: anInteger [ 

	^ profilerModel rootTallyItemsOver: anInteger
]

{ #category : #private }
ProfilerViewModel >> runBlockAndProfile: aBlock [

	[aBlock ensure: [ 
		profilerModel stopProfiling.
		self announcer announce:
			(ProfilingFinishedAnnouncement new success: true) ]] fork
]

{ #category : #api }
ProfilerViewModel >> runProfilerNotifying: requestor [

	| compiledMethod |
	profilerModel := self newProfilerModel.
	profilerModel threshold: profilerThreshold.

	self announcer announce: ProfilingStartedAnnouncement new.

	compiledMethod := Smalltalk compiler
		                  source: self doItSourceCode;
		                  context: nil;
		                  requestor: requestor;
		                  noPattern: true;
		                  failBlock: [ ^ self ];
		                  compile.
		 
	compiledMethod valueWithReceiver: self arguments: #(  )
]

{ #category : #accessing }
ProfilerViewModel >> showLeavesOnly [

	^ showLeavesOnly
]

{ #category : #accessing }
ProfilerViewModel >> showLeavesOnly: anObject [

	showLeavesOnly := anObject
]

{ #category : #accessing }
ProfilerViewModel >> showNodeThreshold [
	^ showNodeThreshold
]

{ #category : #accessing }
ProfilerViewModel >> totalTally [
	^ profilerModel totalTally  
]

{ #category : #accessing }
ProfilerViewModel >> totalTime [
	^ profilerModel totalTime
]
