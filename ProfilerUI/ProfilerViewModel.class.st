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

{ #category : #accessing }
ProfilerViewModel >> leaveItems [
	^ profilerModel leaveItems
]

{ #category : #'accessing nodes' }
ProfilerViewModel >> leaveItemsOver: perCent [
	^ profilerModel leaveItemsOver: perCent
]

{ #category : #constants }
ProfilerViewModel >> newProfilerModel [

	^ profilerModel := self profilerClass newProfilerModel
]

{ #category : #accessing }
ProfilerViewModel >> profileAllProcesses [
	^ profileAllProcesses
]

{ #category : #constants }
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

{ #category : #constants }
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

{ #category : #'accessing roots' }
ProfilerViewModel >> rootTallyItems [

	^ self rootTallyItemsOver: 0
]

{ #category : #'accessing roots' }
ProfilerViewModel >> rootTallyItemsOver: anInteger [ 

	^ profilerModel rootTallyItemsOver: anInteger
]

{ #category : #profiling }
ProfilerViewModel >> runBlockAndProfile: aBlock [

	[aBlock ensure: [ 
		profilerModel stopProfiling.
		self announcer announce:
			(ProfilingFinishedAnnouncement new success: true) ]] fork
]

{ #category : #constants }
ProfilerViewModel >> runProfiler [

	| compiledMethod |
	profilerModel := self newProfilerModel.
	profilerModel threshold: profilerThreshold.
	
	self announcer announce: ProfilingStartedAnnouncement new.
	compiledMethod := Smalltalk compiler
		                  source:
			                  'self runBlockAndProfile: [self profilerModel startProfiling. ' , self code,']';
		                  context: nil;
		                  requestor: self;
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

{ #category : #'accessing roots' }
ProfilerViewModel >> totalTime [
	^ profilerModel totalTime
]
