"
I represent an item in the navigation toolbar used to display the profiling results
"
Class {
	#name : #ProfilerToolbarButtonPresenter,
	#superclass : #SpToolbarButtonPresenter,
	#instVars : [
		'object',
		'node'
	],
	#category : #'ProfilerUI-View'
}

{ #category : #accessing }
ProfilerToolbarButtonPresenter >> node [

	^ node
]

{ #category : #accessing }
ProfilerToolbarButtonPresenter >> node: anObject [

	node := anObject
]

{ #category : #accessing }
ProfilerToolbarButtonPresenter >> object [

	^ object
]

{ #category : #accessing }
ProfilerToolbarButtonPresenter >> object: anObject [

	object := anObject
]
