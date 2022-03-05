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

xxxxx =
#(define-music-function
  (barContent)
  (cheap-list?)
  #{ #@(map
    (lambda (i) #{ \tag #(car i) $(cdr i) #} )
    barContent
  )
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
  
  \tag #'flute    { \clef treble c''4 b' c''2 }
  \tag #'clarinet { \clef treble e'4 f' e'2 }
  \tag #'oboe     { \clef treble e'4 d' e'2 }
  \tag #'bassoon  { \clef bass   g2 c }
  \tag #'celli    { \clef bass   c4 g c'2 }
  |
  
  \xxxxx #(list
    (cons 'flute #{ f'2 g' #} )
    (cons 'oboe  #{ g'2 f' #} )
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
