Class {
	#name : #GtNavigationExamples,
	#superclass : #Object,
	#category : #'GToolkit-Navigation-Examples'
}

{ #category : #examples }
GtNavigationExamples >> navigationOnTabs [

	<gtExample>
	<noTest>
	<description: 'Tabs with glamorous look'>
	| aTabGroup aNavEventFilter |
	aTabGroup := BrTabGroup new.
	aTabGroup aptitude: BrGlamorousTabGroupAptitude new.

	aTabGroup addTab: (BrTab new
			 aptitude: BrGlamorousTabAptitude new;
			 label: 'Tab 1';
			 stencil: [ 
				 BlElement new
					 constraintsDo: [ :c | 
						 c horizontal exact: 300.
						 c vertical exact: 150 ];
					 margin: (BlInsets all: 10);
					 background: (Color red alpha: 0.2) ]).

	aTabGroup addTab: (BrTab new
			 aptitude: BrGlamorousTabAptitude new;
			 label: 'Tab 2';
			 stencil: [ 
				 BlElement new
					 margin: (BlInsets all: 10);
					 constraintsDo: [ :c | 
						 c horizontal matchParent.
						 c vertical exact: 50 ];
					 background: (Color blue alpha: 0.2) ]).

	aTabGroup addTab: (BrTab new
			 aptitude: BrGlamorousTabAptitude new;
			 label: 'Tab 3';
			 stencil: [ 
				 BlElement new
					 constraintsDo: [ :c | 
						 c horizontal matchParent.
						 c vertical exact: 100 ];
					 margin: (BlInsets all: 10);
					 background: (Color orange alpha: 0.2) ]).

	aNavEventFilter := GtNavigationEventFilter new.
	aTabGroup addEventFilter: aNavEventFilter.
	aNavEventFilter handleEvent:
		(GtNavigationShowWish new currentTarget: aTabGroup).

	^ aTabGroup
]
