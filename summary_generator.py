import nltk
from nltk.corpus import stopwords
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.probability import FreqDist
import heapq
import string

nltk.download('punkt')
nltk.download('stopwords')

def preprocess_text(text):
    sentences = sent_tokenize(text, language='spanish')
    words = word_tokenize(text.lower(), language='spanish')
    words = [word for word in words if word not in stopwords.words('spanish') and word not in string.punctuation]
    return sentences, words

def compute_word_frequencies(words):
    fdist = FreqDist(words)
    return fdist

def score_sentences(sentences, word_frequencies):
    sentence_scores = {}
    for sentence in sentences:
        words = word_tokenize(sentence.lower(), language='spanish')
        sentence_length = len(words)
        for word in words:
            if word in word_frequencies:
                if sentence not in sentence_scores:
                    sentence_scores[sentence] = word_frequencies[word]
                else:
                    sentence_scores[sentence] += word_frequencies[word]
        sentence_scores[sentence] = sentence_scores[sentence] / sentence_length
    return sentence_scores

def generate_summary(text, num_sentences=3):
    sentences, words = preprocess_text(text)
    word_frequencies = compute_word_frequencies(words)
    sentence_scores = score_sentences(sentences, word_frequencies)
    summary_sentences = heapq.nlargest(num_sentences, sentence_scores, key=sentence_scores.get)
    summary = ' '.join(summary_sentences)
    return summary
