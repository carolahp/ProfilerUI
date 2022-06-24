"
Same as FTRootItem, but I store a reference to my parent and other calculated variables to prevent recursive calls
"
Class {
	#name : #ProfilerFTRootItem,
	#superclass : #FTRootItem,
	#category : #'ProfilerUI-Morphic'
}

{ #category : #accessing }
ProfilerFTRootItem >> data: aCollection [

	self children: (aCollection collect: [ :object | 
			 (ProfilerFTBasicItem
				 data: object from: dataSource)
				 parent: self;
				 yourself ]) asArray
]
