import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

import com.leff.midi.MidiFile;
import com.leff.midi.MidiTrack;
import com.leff.midi.event.MidiEvent;
import com.leff.midi.event.NoteOn;
import com.leff.midi.event.NoteOff;
import com.leff.midi.event.meta.Tempo;
import com.leff.midi.util.MidiEventListener;
import com.leff.midi.util.MidiProcessor;

public class MidiAnalysis {

	private String mLabel;
	private String midiname;
	
	public MidiAnalysis(String label, String mname) {
		mLabel = label;
		midiname = mname;
	}
	
	private float bpm;
	private float spb;
	private float[][] beats;
	private long[] noteStart = new long[1000];
	private long[] noteEnd = new long[1000];
	private int notestartCount = 0;
	private int noteendCount = 0;
	private ArrayList<Integer> noteVals = new ArrayList<Integer>();
		
    private void setBPM(float b) {
      bpm = b;
      spb =  (60.0f / b);
    }
    
    public float getBPM() {
    	return bpm;
    }
    
    public float getSPB() {
    	return spb;
    }
    
    public float[][] getBeats() {
    	return beats;
    }
    
    private void setNoteStart(long s) {
      noteStart[notestartCount] = s;
      notestartCount++;
    }
    
    private void setNoteEnd(long s) {
      noteEnd[noteendCount] = s;
      noteendCount++;
    }
    
    // Makes an array of beats from timing info of each note. Must be called after each track analysis
    private float[] makeBeats() {
      float[] tempBeats = new float[noteendCount];
      float songLengthSeconds = (1/bpm) * (notestartCount) * 60;
      float mult = songLengthSeconds / (noteStart[noteendCount-1] + noteStart[1]);
      for(int beatCount=0; beatCount < noteendCount; beatCount++) {
        long noteLength = noteEnd[beatCount] - noteStart[beatCount];
        //long noteLengthMS = MidiUtil.ticksToMs(noteLength,bpm,32980000);
        float noteLengthSeconds = noteLength * mult;
        System.out.println("length of note: " + noteLength + " ticks");
        System.out.println("length of note: " + noteLengthSeconds + " seconds");
        float beat = noteLengthSeconds / spb;
        tempBeats[beatCount] = beat;
        System.out.println("made a beat of length: " + beat);
      }
      notestartCount = 0;
      noteendCount = 0;
      return tempBeats;
      //System.out.println("total number of beats: " + (beats.length));
    }
    
    // Goes through midi file looking for beats with notes not yet encountered,
    // and records timing information if a new note is encountered.
    private Boolean iterate(Iterator<MidiEvent> it) {
    	int noteval = 0;
    	int thisval;
    	Boolean anotherVal = false;
		while(it.hasNext()) {
		  MidiEvent E = it.next();
		  if(E.getClass().equals(NoteOn.class)) {
		    //System.out.println("noteOn tick: " + E.getTick());
			NoteOn note = (NoteOn) E;
			thisval = note.getNoteValue();
			//System.out.println(thisval);
			if (!(noteVals.contains(thisval)) && noteval==0 ) {
              noteVals.add(thisval);
              noteval = thisval;
              anotherVal = true;
			}
			if (thisval==noteval)
			  setNoteStart(E.getTick());
		  }
	      if(E.getClass().equals(NoteOff.class)) {
		    //System.out.println("noteOff tick: " + E.getTick());
	    	NoteOff note = (NoteOff) E;
	    	if (note.getNoteValue()==noteval)
		      setNoteEnd(E.getTick());
		  }
		}
		return anotherVal;
    }
    
	public void analyzeIt() {
		// 1. Read in a MidiFile
		MidiFile midi = null;
		try {
			midi = new MidiFile(new File(midiname));
		} catch(IOException e) {
			System.err.println(e);
			System.exit(1);
		}
		// 2. Extract tempo data from midi file
		MidiTrack T = midi.getTracks().get(0);
		Iterator<MidiEvent> itT = T.getEvents().iterator();
		while(itT.hasNext()) {
			MidiEvent E = itT.next();	
			if(E.getClass().equals(Tempo.class)) {
		      Tempo t = (Tempo) E;
	          setBPM(t.getBpm());
			}	
		}
		// 3. Extract each track and translate them to temporary thebeats array
		MidiTrack N = midi.getTracks().get(1);
		Iterator<MidiEvent> itN = N.getEvents().iterator();
		Boolean moreTracks = true;
		int tracks = 0;
		float[][] thebeats = new float[8][1000]; 
		while(moreTracks){
			itN = N.getEvents().iterator();
			moreTracks = iterate(itN);
			if (moreTracks){
				System.out.println(noteVals.get(tracks));
				thebeats[tracks] = makeBeats();
				tracks++;
			}
		}
		
		// 4. translate extracted tracks to clean 2-d array of beats
		beats = new float[tracks][];
		for(int i=0; i < (tracks); i++) {
          beats[i] = thebeats[i];
		}
	}
}

