"
I am a graphical user interface for profiling code using different kinds of profilers
"
Class {
	#name : #ProfilerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'inputPresenter',
		'resultsPresenter',
		'viewModel'
	],
	#category : #'ProfilerUI-View'
}

{ #category : #examples }
ProfilerPresenter class >> open [

	<example>
	
	^ self new openWithSpec
]

{ #category : #TOREMOVE }
ProfilerPresenter >> initialExtent [
	^ 800 @ 500
]

{ #category : #initialization }
ProfilerPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
			 add: (inputPresenter := self newInputPresenter) height: 100;
			 add: (resultsPresenter := self newResultsPresenter) expand: true;
			 yourself)
]

{ #category : #initialization }
ProfilerPresenter >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: self title;
		initialExtent: self initialExtent;
		whenClosedDo: [ self unsubscribe ].

]

{ #category : #initialization }
ProfilerPresenter >> newInputPresenter [

	^ ProfilerInputPresenter withViewModel: self viewModel
]

{ #category : #initialization }
ProfilerPresenter >> newResultsPresenter [

	^ ProfilerResultsPresenter withViewModel: self viewModel
]

{ #category : #TOREMOVE }
ProfilerPresenter >> title [
	^ 'Profiler'
]

{ #category : #initialization }
ProfilerPresenter >> unsubscribe [
	
	resultsPresenter unsubscribeFromProfilingAnnouncements.
	inputPresenter unsubscribeFromProfilingAnnouncements.
	
]

{ #category : #accessing }
ProfilerPresenter >> viewModel [

	^ viewModel ifNil: [ viewModel := ProfilerViewModel new ]
]
