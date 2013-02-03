
public class test {
	
	public static void main(String[] args) {
		MidiAnalysis ma = new MidiAnalysis("MeatAnalyzer","OneTrackAlternatingRhythms.mid");
		ma.analyzeIt();
		System.out.println("BPM = " + ma.getBPM());
		System.out.println("SPB = " + ma.getSPB());
		float[][] beats = ma.getBeats();
		System.out.println("BEATS.LENGTH = " + beats.length);
		for(int i=0; i < beats.length; i++) {
		  for(int j=0; j < beats[i].length; j++) {
            System.out.println("Length of track " + (i+1) + ", beat " + j + "= " + beats[i][j]);
		  }
		}
	}
	
}