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
		'showLeavesOnly'
	],
	#category : #'ProfilerUI-ViewModel'
}

{ #category : #constants }
ProfilerViewModel >> allProfilerClasses [

	^ { AndreasSystemProfiler . TimeProfiler . PreciseProfiler }
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

{ #category : #accessing }
ProfilerViewModel >> defaultTreeVisualizationItem [

	^ 'Full tree' -> false
]

{ #category : #initialize }
ProfilerViewModel >> initialize [ 
	super initialize.
	showLeavesOnly := false.
	profileAllProcesses := true.
	code := '10000 factorial'
]

{ #category : #accessing }
ProfilerViewModel >> leaveItems [
	| res  |
	res := OrderedCollection new.
	self rootTallyItems 
		ifNotNil: [ 
			| dict |
			dict := IdentityDictionary new: 100.
			self rootTallyItems leavesInto: dict fromSender: nil.
			res addAll: dict asOrderedCollection ].
	^ res
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
ProfilerViewModel >> rootItems [

	^ showLeavesOnly
		ifTrue: [ self leaveItems ]
		ifFalse: [ self rootTallyItems ]
]

{ #category : #'accessing profiler' }
ProfilerViewModel >> rootTallyItems [

	^ profilerModel rootTallyItems 
]

{ #category : #profiling }
ProfilerViewModel >> runBlockAndProfile: aBlock [

	[aBlock ensure: [ 
		profilerModel stopProfiling.
		profilerModel doReport.

		self announcer announce:
			(ProfilingFinishedAnnouncement new success: true) ]] fork
]

{ #category : #constants }
ProfilerViewModel >> runProfiler [

	| compiledMethod |
	profilerModel := self newProfilerModel.
	profilerModel threshold: 0 asInteger.
	profilerModel minTime: 0 asFloat.
	
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
ProfilerViewModel >> totalTally [
	^ profilerModel totalTally  
]

{ #category : #'accessing profiler' }
ProfilerViewModel >> totalTime [
	^ profilerModel totalTime
]

{ #category : #accessing }
ProfilerViewModel >> treeVisualizationItems [

	^ { 
		  ('Full tree' -> false).
		  ('Leaves' -> true) }
]
