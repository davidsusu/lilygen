\version "2.18.2"

headerData = \header {
  title = "Music piece"
  composer = "John Doe"
  date = "1900-01-01"
}

% define instruments here
instruments = #'(
  ; tag name shortName midiInstrument
  ( flute "Flute" "Fl" "flute" )
  ( clarinet "Clarinet" "Cl" "clarinet" )
  ( oboe "Oboe" "Ob" "oboe" )
  ( bassoon "Bassoon" "Bs" "bassoon" )
  ( celli "Celli" "Ci" "cello" )
)

instrumentLabels = #(map
  (lambda (i) (list-ref i 0))
  instruments
)

#(define (diff s1 s2)
  (cond
    ((null? s1) '())
    ((not (member (car s1) s2)) (cons (car s1) (diff (cdr s1) s2)))
    (else (diff (cdr s1) s2))
  )
)

createBar =
#(define-music-function
  (len barContent)
  (number? cheap-list?)
  #{
    #@(map
      (lambda (i) #{ \tag #(car i) $(cdr i) #} )
      barContent
    )
    #@(map
      (lambda (label) #{ \tag #label #(make-music 'MultiMeasureRestMusic 'duration (ly:make-duration 0 0 len)) #} )
      (diff instrumentLabels (map (lambda (i) (list-ref i 0)) barContent))
    )
    |
  #}
)

data = {
  \override Score.RehearsalMark.minimum-space = 5
  \override Score.RehearsalMark.self-alignment-X = #LEFT
  \set Score.tempoHideNote = ##t
  
  % set initial instructions here
  \mark \markup { \bold "Some movement" }
  \tempo 4 = 90
  \time 4/4
    \set Timing.beamExceptions = #'()
    \set Timing.baseMoment = #(ly:make-moment 1/4)
    \set Timing.beatStructure = #'(1 1 1 1)
  \key c \major
    \accidentalStyle modern
  
  \createBar #1 #(list
    (cons 'flute    #{ \clef treble c''4 b' c''2 #} )
    (cons 'clarinet #{ \clef treble e'4 f' e'2 #} )
    (cons 'oboe     #{ \clef treble e'4 d' e'2 #} )
    (cons 'bassoon  #{ \clef bass   g2 c #} )
    (cons 'celli    #{ \clef bass   c4 g c'2 #} )
  )
  
  \createBar #1 #(list
    (cons 'flute #{ f'2 g' #} )
    (cons 'oboe  #{ g'2 f' #} )
  )
  
  \repeat unfold 3 { 
    \createBar #1 #(list
      (cons 'celli #{ c16 d e f g a b c' d' c' b a g f e d #} )
    )
  }
  
  \createBar #1 #(list
    (cons 'celli  #{ c1 #} )
  )
  
  \break
  
  \createBar #1 #(list
    (cons 'flute    #{ \clef treble c''1 #} )
    (cons 'clarinet #{ \clef treble c''1 #} )
    (cons 'oboe     #{ \clef treble e'1 #} )
    (cons 'bassoon  #{ \clef bass   g1 #} )
    (cons 'celli    #{ \clef bass   c'1 #} )
  )
  
  \createBar #1 #(list
    (cons 'flute    #{ \clef treble c''1 #} )
    (cons 'clarinet #{ \clef treble b'1 #} )
    (cons 'oboe     #{ \clef treble f'1 #} )
    (cons 'bassoon  #{ \clef bass   as1 #} )
    (cons 'celli    #{ \clef bass   g1 #} )
  )
  
  \createBar #1 #(list
    (cons 'flute    #{ \clef treble c''1 #} )
    (cons 'clarinet #{ \clef treble c''1 #} )
    (cons 'oboe     #{ \clef treble e'1 #} )
    (cons 'bassoon  #{ \clef bass   g1 #} )
    (cons 'celli    #{ \clef bass   c1 #} )
  )
  
  \bar "|."
  
}

\include "articulate.ly"

#(define custom-instrument-equalizer-alist '() )

#(set! custom-instrument-equalizer-alist
  (append
    '() ; add custom midi equalizer settings here
    custom-instrument-equalizer-alist
  )
)

#(define
  (custom-instrument-equalizer s)
  (let
    ((entry (assoc s custom-instrument-equalizer-alist) ))
    (if entry (cdr entry) )
  )
)

\book {
  \bookOutputName "out/score"
  
  \score {
    \new StaffGroup <<
      #@(map (lambda (i)
        #{ \new Staff \with { instrumentName = #(list-ref i 1) shortInstrumentName = #(list-ref i 2) } << \keepWithTag #(list 'score (list-ref i 0)) \data >> #} )
        instruments
      )
    >>
    
    \layout {
      \context {
        \RemoveEmptyStaffContext
      }
    }
  }
  
  \score {
    \unfoldRepeats
    \articulate
    
    \new StaffGroup <<
      #@(map (lambda (i)
        #{ \new Staff << \set Staff.midiInstrument = #(list-ref i 3) \keepWithTag #(list 'midi (list-ref i 0)) \data >> #} )
        instruments
      )
    >>
    
    \midi {
      \set Score.instrumentEqualizer = #custom-instrument-equalizer
    }
  }
  
  \paper {
    max-systems-per-page = 3
  }
  
  \headerData
}
