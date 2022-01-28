"
I announce when the profiling process has finished
"
Class {
	#name : #ProfilingFinishedAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'success'
	],
	#category : #'ProfilerUI-Announcements'
}

{ #category : #accessing }
ProfilingFinishedAnnouncement >> success [
	^ success
]

{ #category : #accessing }
ProfilingFinishedAnnouncement >> success: aBoolean [
	success := aBoolean
]
