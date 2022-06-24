"
I am the adapter used to realise a ProfilerTreeTablePresenter.

I will create a tree table (using FTTableMorph), but my datasource uses ProfilerFTBasicItem and ProfilerFTRoot item, which optimize the performance rendering the tree, but use more memory.
"
Class {
	#name : #SpMorphicProfilerTreeTableAdapter,
	#superclass : #SpMorphicTreeTableAdapter,
	#category : #'ProfilerUI-SpecAdapters'
}

{ #category : #private }
SpMorphicProfilerTreeTableAdapter >> rootForItems: aCollection [

	^ ProfilerFTRootItem new
		data: aCollection;
		yourself
]
