"
I am a controller used by the ProfilerPresenter to interact with different kinds of profiler models
"
Class {
	#name : #ProfilerModel,
	#superclass : #MorphTreeModel,
	#instVars : [
		'code',
		'profilerClass',
		'profileAllProcesses',
		'showLeavesOnly',
		'showNodeThreshold',
		'profiler',
		'tallyRoot',
		'isProfiling'
	],
	#category : #'ProfilerUI-Model'
}

{ #category : #constants }
ProfilerModel >> allProfilerClasses [

	^ { AndreasSystemProfiler . TimeProfiler ". PreciseProfiler" }
]

{ #category : #'event handling' }
ProfilerModel >> browseItem [
	self selectedNode ifNotNil: [:current | current browseItem ].

]

{ #category : #constants }
ProfilerModel >> doItSelectorsPath [
	^ #( 'newProcess' 'runBlockAndProfile:' 'ensure:' 'DoIt' 'DoIt' )
]

{ #category : #constants }
ProfilerModel >> doItSourceCode [
	^ 'self runBlockAndProfile: [self startProfiling. [' , code,'] value ]'
]

{ #category : #reporting }
ProfilerModel >> doReport [
	
	^ String streamContents: [ :s | 
		profiler report: s cutoff: 0 ]
]

{ #category : #'help-text' }
ProfilerModel >> helpText [
	^ 'Method, Block or Primitive node'
]

{ #category : #api }
ProfilerModel >> hideNodesUnder: aNumber [
	"minimum percentage a node must have to be shown"
	showNodeThreshold := aNumber
]

{ #category : #initialization }
ProfilerModel >> initialize [ 
	super initialize.
	showLeavesOnly := false.
	showNodeThreshold := 0.
	profileAllProcesses := true.
	code := '10000 factorial'
]

{ #category : #accessing }
ProfilerModel >> isProfiling [
	^ isProfiling ifNil: [ isProfiling := false ]
]

{ #category : #'event handling' }
ProfilerModel >> keyDown: aKeyboardEvent from: aMorphTreeListManager [ 
	self selectedNode ifNotNil: [:current | current keyDown: aKeyboardEvent from: aMorphTreeListManager ]
]

{ #category : #'accessing nodes' }
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

{ #category : #'accessing nodes' }
ProfilerModel >> leaveItemsOver: perCent [

	| leaveThreshold |
	leaveThreshold := (perCent asFloat / 100 * self tallyRoot tally) rounded.
	^ self leaveItems select: [ :item | item tally > leaveThreshold ]
]

{ #category : #accessing }
ProfilerModel >> menu: menu shifted: b [ 
	"Set up the menu to apply to the receiver's, honoring the #shifted boolean"
	
	self selectedNode 
		ifNotNil: [ :current | 
			current menu: menu shifted: b.
			menu addLine.
			menu
				add: 'Expand all from here'
				target: self
				selector: #expandAllFromNode:
				argument: current .
			menu addLine.
			menu 
				add: 'Go into node'
				target: self
				selector: #setTallyRoot:
				argument: current ].
	^ menu
]

{ #category : #factory }
ProfilerModel >> newProfiler [
	^ self profilerClass new
]

{ #category : #accessing }
ProfilerModel >> profileAllProcesses [
	^ profileAllProcesses
]

{ #category : #accessing }
ProfilerModel >> profileAllProcesses: aBoolean [
	profileAllProcesses := aBoolean
]

{ #category : #api }
ProfilerModel >> profileCode: someCode notifying: requestor [

	| compiledMethod |
	self isProfiling ifTrue: [ profiler stopProfiling ].
	profiler := self newProfiler.
	code := someCode.
	
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
ProfilerModel >> profilerClass [
	^ profilerClass ifNil: [ profilerClass := self allProfilerClasses at: 1 ]
]

{ #category : #accessing }
ProfilerModel >> profilerClass: aClass [
	profilerClass := aClass
]

{ #category : #accessing }
ProfilerModel >> rootItems [

	^ showLeavesOnly
		  ifTrue: [ self leaveItemsOver: showNodeThreshold ]
		  ifFalse: [ self rootTallyItemsOver: showNodeThreshold ]
]

{ #category : #accessing }
ProfilerModel >> rootNodeFromItem: anItem [

	^ anItem asTallyModel
]

{ #category : #accessing }
ProfilerModel >> rootNodes [

	profiler ifNil: [ ^ nil ].
	^ super rootNodes
]

{ #category : #'accessing nodes' }
ProfilerModel >> rootTallyItems [

	^ self rootTallyItemsOver: 0
]

{ #category : #'accessing nodes' }
ProfilerModel >> rootTallyItemsOver: perCent [
	| minTally |
	minTally := (perCent asFloat / 100 * self tallyRoot tally) rounded.
	
	^ (self tallyRoot sonsOver: minTally) 
		ifEmpty: [ #() ]
		ifNotEmpty: [:sons | sons asOrderedCollection sort reverse ] 
]

{ #category : #private }
ProfilerModel >> runBlockAndProfile: aBlock [

	[aBlock ensure: [ 
		self stopProfiling.
		self announcer announce:
			(ProfilingFinishedAnnouncement new success: true) ]] fork
]

{ #category : #'accessing nodes' }
ProfilerModel >> setTallyRoot: anItem [
	self tallyRoot: anItem item.
	self announcer announce: (ProfilerResultsTreeRootChangedAnnouncement new item: anItem)
]

{ #category : #accessing }
ProfilerModel >> showLeavesOnly [

	^ showLeavesOnly
]

{ #category : #accessing }
ProfilerModel >> showLeavesOnly: anObject [

	showLeavesOnly := anObject
]

{ #category : #accessing }
ProfilerModel >> showNodeThreshold [
	^ showNodeThreshold
]

{ #category : #profiling }
ProfilerModel >> startProfiling [
	
	isProfiling := true.
	profiler startProfiling
]

{ #category : #profiling }
ProfilerModel >> stopProfiling [

	profiler stopProfiling.
	isProfiling := false
]

{ #category : #'accessing nodes' }
ProfilerModel >> tallyRoot [

	^ tallyRoot ifNil: [ 
		  tallyRoot := profiler tallyRoot asTallyModel
			               model: self;
			               yourself ]
]

{ #category : #'accessing nodes' }
ProfilerModel >> tallyRoot: aTallyObject [

	tallyRoot := aTallyObject asTallyModel
			               model: self;
			               yourself
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
