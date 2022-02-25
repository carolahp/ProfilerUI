"
I am a controller used by the ProfilerPresenter to interact with different kinds of profiler models
"
Class {
	#name : #ProfilerController,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'profilerModel',
		'code',
		'profilerClass',
		'profileAllProcesses'
	],
	#category : #'ProfilerUI-Controller'
}

{ #category : #constants }
ProfilerController >> allProfilerClasses [

	^ { AndreasSystemProfiler . TimeProfiler . PreciseProfiler }
]

{ #category : #accessing }
ProfilerController >> announcer [ 
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #constants }
ProfilerController >> code [
	^ code
]

{ #category : #accessing }
ProfilerController >> code: aString [ 
	code := aString
]

{ #category : #constants }
ProfilerController >> newProfilerModel [

	^ profilerModel := self profilerClass newProfilerModel
]

{ #category : #constants }
ProfilerController >> profileAllProcesses: aBoolean [
	profileAllProcesses := aBoolean
]

{ #category : #accessing }
ProfilerController >> profilerClass [
	^ profilerClass ifNil: [ profilerClass := self allProfilerClasses at: 1 ]
]

{ #category : #accessing }
ProfilerController >> profilerClass: aClass [
	profilerClass := aClass
]

{ #category : #constants }
ProfilerController >> profilerModel [

	^ profilerModel
]

{ #category : #'accessing profiler' }
ProfilerController >> rootTallyItems [
	^ profilerModel rootTallyItems 
]

{ #category : #constants }
ProfilerController >> runProfiler [

	| compiledMethod |
	profilerModel := self newProfilerModel.
	profilerModel threshold: 0 asInteger.
	profilerModel minTime: 0 asFloat.
	[ 
	self announcer announce: ProfilingStartedAnnouncement new.
	compiledMethod := Smalltalk compiler
		                  source:
			                  'self profilerModel startProfiling. ' , self code;
		                  context: nil;
		                  requestor: self;
		                  noPattern: true;
		                  failBlock: [ ^ self ];
		                  compile.
	compiledMethod valueWithReceiver: self arguments: #(  ) ] ensure: [ 
		profilerModel stopProfiling.
		profilerModel doReport.
		self announcer announce:
			(ProfilingFinishedAnnouncement new success: true) ]
]

{ #category : #'accessing profiler' }
ProfilerController >> totalTime [
	^ profilerModel totalTime
]
