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
		'viewModel'
	],
	#category : #'ProfilerUI-View'
}

{ #category : #initialization }
ProfilerInputPresenter >> initializeActions [

	profilerDropList whenSelectedItemChangedDo: [ :item | 
		viewModel profilerClass: item ].

	allProcessesCheckbox whenChangedDo: [ :state | 
		viewModel profileAllProcesses: state ].

	profileItButton action: [ 
		viewModel profileCode: codeInput text notifying: self ]
]

{ #category : #initialization }
ProfilerInputPresenter >> initializePresenters [
	codeInput := self newCode beForScripting.

	profilerDropList := self newDropList
		                    help: 'Select the desired profiler.';
		                    items: viewModel allProfilerClasses;
		                    selectItem: viewModel profilerClass;
		                    display: [ :each | each name ];
		                    disable.

	allProcessesCheckbox := self newCheckBox
		                        label: 'Profile all processes';
		                        state: viewModel profileAllProcesses;
		                        enabled: false.

	profileItButton := self newButton
		                   icon: (self iconNamed: #glamorousGo);
		                   label: 'Profile it'.
	
	self layout: (SpBoxLayout newLeftToRight
			 add: codeInput;
			 add: (SpBoxLayout newTopToBottom
					  add: profilerDropList;
					  add: allProcessesCheckbox;
					  add: profileItButton;
					  yourself)
			 expand: false
			 fill: false
			 padding: 5;
			 yourself).

	self focusOrder
		add: codeInput;
		add: profileItButton.
		
	self subscribeOnProfilingAnnouncements.
	self initializeActions
]

{ #category : #'error handling' }
ProfilerInputPresenter >> notify: errorMessage at: positionIndex in: sourceCode [ 

	codeInput notify: errorMessage at: positionIndex in: sourceCode 

]

{ #category : #'accessing - model' }
ProfilerInputPresenter >> setModelBeforeInitialization: aDomainObject [

	viewModel := aDomainObject
]

{ #category : #initialization }
ProfilerInputPresenter >> subscribeOnProfilingAnnouncements [
	viewModel announcer 
		when: ProfilingStartedAnnouncement 
		do: [ self enabled: false ];
		
		when: ProfilingFinishedAnnouncement 
		do: [ self enabled: true ].
	
]

{ #category : #initialization }
ProfilerInputPresenter >> unsubscribeFromProfilingAnnouncements [
	viewModel announcer unsubscribe: self
]

{ #category : #accessing }
ProfilerInputPresenter >> viewModel [
	^ viewModel
]

{ #category : #accessing }
ProfilerInputPresenter >> viewModel: aProfilerViewModel [ 
	viewModel := aProfilerViewModel
]
