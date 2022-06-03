Class {
	#name : #GtNavigationStatus,
	#superclass : #BlElement,
	#instVars : [
		'label'
	],
	#classInstVars : [
		'label'
	],
	#category : #'GToolkit-Navigation-UI'
}

{ #category : #initialization }
GtNavigationStatus class >> for: aNavigation [

	^ self basicNew initialize
]

{ #category : #initialization }
GtNavigationStatus >> initialize [

	super initialize.
	label := BrLabel new
		         text: '';
		         aptitude: BrGlamorousLabelAptitude new.
	self addChild: label
]

{ #category : #accessing }
GtNavigationStatus >> text: aString [

	label text: aString
]
