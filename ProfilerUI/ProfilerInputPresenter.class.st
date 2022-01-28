"
I am a panel in the ProfilerPresenter containing user defined inputs to start profiling
"
Class {
	#name : #ProfilerInputPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'profilerDropList',
		'allProcessesCheckbox',
		'profileItButton',
		'codeInput',
		'controller'
	],
	#category : #'ProfilerUI-View'
}

{ #category : #'instance creation' }
ProfilerInputPresenter class >> withController: aProfilerController [
	^ self basicNew
		controller: aProfilerController;
		initialize;
		yourself
]

{ #category : #accessing }
ProfilerInputPresenter >> controller: aProfilerController [ 
	controller := aProfilerController
]

{ #category : #initialization }
ProfilerInputPresenter >> initializeActions [

	codeInput whenTextChangedDo: [ :text | controller code: text ].

	profilerDropList whenSelectedItemChangedDo: [ :item | 
		controller profilerClass: item ].

	allProcessesCheckbox whenChangedDo: [ :state | 
		controller profileAllProcesses: state ].

	profileItButton action: [ controller runProfiler ]
]

{ #category : #initialization }
ProfilerInputPresenter >> initializePresenters [

	codeInput := self newCode
		             text: '10000 factorial'.

	profilerDropList := self newDropList
		                    help: 'Select the desired profiler.';
		                    items: controller allProfilerClasses;
		                    selectItem: controller profilerClass;
		                    display: [ :each | each name ].

	allProcessesCheckbox := self newCheckBox
		                        label: 'All processes';
		                        state: true;
		                        enabled: false.

	profileItButton := self newButton
		                   icon: (self iconNamed: #glamorousGo);
		                   label: 'Profile it'.

	self layout: (SpBoxLayout newTopToBottom
			 add: codeInput;
			 add: (SpBoxLayout newLeftToRight
					  add: profilerDropList;
					  add: allProcessesCheckbox width: 100;
					  add: profileItButton width: 100;
					  yourself)
			 height: self class toolbarHeight;
			 yourself).

	self focusOrder
		add: codeInput;
		add: profileItButton.
	self initializeActions
]

{ #category : #initialization }
ProfilerInputPresenter >> subscribeOnProfilingAnnouncements [
	controller announcer when: ProfilingStartedAnnouncement do: [ self error: 'to do: disable inputs' ].
]

{ #category : #initialization }
ProfilerInputPresenter >> unsubscribeFromProfilingAnnouncements [
	controller announcer unsubscribe: self
]
