"
I represent an item in the navigation toolbar used to display the profiling results
"
Class {
	#name : #ProfilerToolbarButtonPresenter,
	#superclass : #SpToolbarButtonPresenter,
	#instVars : [
		'object'
	],
	#category : #'ProfilerUI-View'
}

{ #category : #accessing }
ProfilerToolbarButtonPresenter >> object [

	^ object
]

{ #category : #accessing }
ProfilerToolbarButtonPresenter >> object: anObject [

	object := anObject
]
