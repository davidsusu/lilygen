\version "2.18.2"

headerData = \header {
  title = "Music piece"
  composer = "John Doe"
  date = "1900-01-01"
}

% define instruments here
instruments = #'(
  ; tag name shortName midiInstrument
  ( violin1 "Violin 1" "V1" "flute" )
  ( violin2 "Violin 2" "V2" "clarinet" )
  ( viola "Viola" "Va" "oboe" )
  ( cello "Cello" "C" "cello" )
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
  
  % write your music here
  \tag #'violin1 { \clef treble c'16 c' c' c' c' c' c' c' c'2 }
  \tag #'violin2 { \clef treble c'1 }
  \tag #'viola   { \clef alto   c'1 }
  \tag #'cello   { \clef bass   c'1 }
  |
  
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
