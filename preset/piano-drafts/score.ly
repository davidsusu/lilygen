\version "2.18.2"

headerData = \header {
  title = "Piano sketches"
  composer = "John Doe"
  date = "1900-01-01"
}

snippets = #(list)
midiExtraction = #(list)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

title = "Snippet 1"
music = {
  \time 4/4
    \set Timing.beamExceptions = #'()
    \set Timing.baseMoment = #(ly:make-moment 1/4)
    \set Timing.beatStructure = #'(1 1 1 1)
  \key c \major
  
  \tag #'right { \clef treble c'4 d' e' f' }
  \tag #'left  { \clef bass   c4 d e f }
  {
    |
    \tag #'right { \clef treble g'2 c'' }
    \tag #'left  { \clef bass   << { g4. fis8 g e g4 } \\ { g8 f e d c2 } >> }
  }
}
snippets = #(append! snippets (list (list title music)))
%midiExtraction = #(append! midiExtraction (list (list title music)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

title = "Snippet 2"
music = {
    \time 4/4
      \set Timing.beamExceptions = #'()
      \set Timing.baseMoment = #(ly:make-moment 1/4)
      \set Timing.beatStructure = #'(1 1 1 1)
    \key c \major
    
    \tag #'right { \clef treble c'2 d' }
    \tag #'left  { \clef bass   c2 d }
    |
    \tag #'right { \clef treble <c' e'>1 }
    \tag #'left  { \clef bass   <c e g>1 }
}
snippets = #(append! snippets (list (list title music)))
%midiExtraction = #(append! midiExtraction (list (list title music)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\include "articulate.ly"

initStaff = {
  \accidentalStyle modern
}

\book {
  \bookOutputName "out/score"
  
  \tagGroup #'(left right)
  \tagGroup #'(scoreOnly midiOnly)

  $@(map (lambda (item)
    #{ \score {
      
      \header {
        piece = $(list-ref item 0)
      }
      
      \layout {
        indent = 0.0
      }
      
      \new PianoStaff <<
        \new Staff { \initStaff \keepWithTag #(list 'scoreOnly) \keepWithTag #(list 'right) $(list-ref item 1) }
        \new Staff { \initStaff \keepWithTag #(list 'scoreOnly) \keepWithTag #(list 'left) $(list-ref item 1) }
      >>
    } #} )
    snippets
  )
  
  $@(map (lambda (item)
    #{ \score {
      \midi {
      }
      \new StaffGroup <<
        \set midiInstrument = "acoustic grand"
        \new Staff { \initStaff \keepWithTag #(list 'midiOnly) \keepWithTag #(list 'right) $(list-ref item 1) }
        \new Staff { \initStaff \keepWithTag #(list 'midiOnly) \keepWithTag #(list 'left) $(list-ref item 1) }
      >>
    } #} )
    midiExtraction
  )
  
  \headerData
}
