"
A presenter for tree with a table used by the ProfilerUI to optimize rendering performance, but using more memory.
"
Class {
	#name : #ProfilerTreeTablePresenter,
	#superclass : #SpTreeTablePresenter,
	#category : #'ProfilerUI-View'
}

{ #category : #specs }
ProfilerTreeTablePresenter class >> adapterName [ 

	^ #ProfilerTreeTableAdapter
]
