#!/usr/bin/perl



#my @stopwords=("a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the");
#my %hash = @stopwords;

my %hash_em_words=(
	"joy"  => "happy",
    	"anger" => "angry",
    	"sad"  => "sad",
        "fear"  => "afraid",
    	"disgust" => "disgusting",
    	"surprise"  => "surprised");
my %hash_dict=();
my @features=();
my %hash_sent=();


open (IN, '<:encoding(UTF-8)',"D:/IEST_Shared_Task_WASSA2018/train.csv/train.csv") || die "cannot open file";

while (<IN>)
{
	$line = $_;
        chomp($line);
        @comps=split ('\t', $line);

        $emotion = $hash_em_words{$comps[0]};

        $comps[1]=~s/"\@USERNAME"//g;
        $comps[1]=~s/"[#TRIGGERWORD#]"/$emotion/g;

        $text=lc($comps[1]);
        $text =~s/[^A-Za-z\s\/]//g;
        $text =~s/\s+/ /g;
        @words = split(' ',$text);
        $size=@words;
        for ($i=0;$i<$size-1;$i++)
	{
        	if (exists($hash_dict{$words[$i]}))
                {
               		 $hash_dict{$words[$i]}++;
                }
                else
                {
                         $hash_dict{$words[$i]}=1;
                         push(@features, $words[$i]);
                }

                $bigram= $words[$i]." ".$words[$i+1];
                if (exists($hash_dict{$bigram}))
                {
               		 $hash_dict{$bigram}++;
                }
                else
                {
                         $hash_dict{$bigram}=1;
                         push(@features, $bigram);
                }

        }
        if (exists($hash_dict{$words[$size-1]}))
                {
               		 $hash_dict{$words[$size-1]}++;
                }
                else
                {
                         $hash_dict{$words[$size-1]}=1;
                         push(@features,$words[$size-1]);
                }



}
close(IN);

open (OUT, '>:encoding(UTF-8)',"TestingIEST_uni_bi_NSR2.arff");

print OUT "\@relation emotion\n";

$nofeatures=@features;


for ($i=0; $i<$nofeatures; $i++)
{
	print OUT "\@attribute feature".$i." REAL\n";
        $hash_dict{$features[$i]}=$i;
}
print OUT "\@attribute relation {joy, anger, fear, sad, disgust, surprise}\n";
print OUT "\@data\n";

open (IN, "D:/IEST_Shared_Task_WASSA2018/trial.csv/trial.csv") || die "cannot open file";
while (<IN>)
{
	$line = $_;
        chomp($line);
        @comps=split ('\t', $line);

        $emotion = $hash_em_words{$comps[0]};

        $comps[1]=~s/"\@USERNAME"//g;
        $comps[1]=~s/"[#TRIGGERWORD#]"/$emotion/g;

        $text=lc($comps[1]);
        $text =~s/[^A-Za-z\s\/]//g;
        $text =~s/\s+/ /g;
        @words = split(' ',$text);
        $size=@words;
        %hash_sent=();
        for ($i=0;$i<$size-1;$i++)
	{
        	if (exists($hash_dict{$words[$i]}))
                {
               		 $hash_sent{$words[$i]}= $hash_dict{$words[$i]};
                }


                $bigram= $words[$i]." ".$words[$i+1];
                if (exists($hash_dict{$bigram}))
                {
               		 $hash_sent{$bigram}=$hash_dict{$bigram};
                }


        }
        if (exists($hash_dict{$words[$size-1]}))
                {
               		 $hash_sent{$words[$size-1]}=$hash_dict{$words[$size-1]};
                }

print OUT "{";

foreach $value (sort {$hash_sent{$a}<=>$hash_sent{$b}}
           keys %hash_sent)
        {
                 print OUT "$hash_sent{$value} 1,";
        }


 print OUT "$nofeatures $comps[0]}\n";

}
close(IN);
close(OUT);





