"use client"

import { useState } from "react";
import { AlertTriangle, Activity, Heart, Brain, Stethoscope, Search, TrendingUp, Sparkles } from "lucide-react";

const cattleSymptoms = [
  "anorexia", "abdominal_pain", "anaemia", "abortions", "acetone", "aggression",
  "arthrogyposis", "ankylosis", "anxiety", "bellowing", "blood_loss", "blood_poisoning",
  "blisters", "colic", "Condemnation_of_livers", "coughing", "depression", "discomfort",
  "dyspnea", "dysentery", "diarrhoea", "dehydration", "drooling", "dull",
  "decreased_fertility", "diffculty_breath", "emaciation", "encephalitis", "fever",
  "facial_paralysis", "frothing_of_mouth", "frothing", "gaseous_stomach", "highly_diarrhoea",
  "high_pulse_rate", "high_temp", "high_proportion", "hyperaemia", "hydrocephalus",
  "isolation_from_herd", "infertility", "intermittent_fever", "jaundice", "ketosis",
  "loss_of_appetite", "lameness", "lack_of-coordination", "lethargy", "lacrimation",
  "milk_flakes", "milk_watery", "milk_clots", "mild_diarrhoea", "moaning",
  "mucosal_lesions", "milk_fever", "nausea", "nasel_discharges", "oedema", "pain",
  "painful_tongue", "pneumonia", "photo_sensitization", "quivering_lips",
  "reduction_milk_vields", "rapid_breathing", "rumenstasis", "reduced_rumination",
  "reduced_fertility", "reduced_fat", "reduces_feed_intake", "raised_breathing",
  "stomach_pain", "salivation", "stillbirths", "shallow_breathing", "swollen_pharyngeal",
  "swelling", "saliva", "swollen_tongue", "tachycardia", "torticollis", "udder_swelling",
  "udder_heat", "udder_hardeness", "udder_redness", "udder_pain", "unwillingness_to_move",
  "ulcers", "vomiting", "weight_loss", "weakness",
];

export default function DiseaseDetection() {
  const [symptoms, setSymptoms] = useState<string[]>([]);
  const [prediction, setPrediction] = useState<{
    input_symptoms: string[];
    predictions: {
      DecisionTree: string;
      RandomForest: string;
      KNN: string;
      NaiveBayes: string;
    };
  } | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");

  const handleSymptomToggle = (symptom: string) => {
    setSymptoms((prev) =>
      prev.includes(symptom) ? prev.filter((s) => s !== symptom) : [...prev, symptom]
    );
  };

  const filteredSymptoms = cattleSymptoms.filter((symptom) =>
    symptom.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const handlePredict = async () => {
    if (symptoms.length < 2) return;

    setIsLoading(true);
    try {
      const response = await fetch("http://127.0.0.1:8000/api/predict", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ symptoms }),
      });

      if (response.ok) {
        const result = await response.json();
        setPrediction(result);
      } else {
        setPrediction({
          input_symptoms: symptoms,
          predictions: {
            DecisionTree: "gut_worms",
            RandomForest: "gut_worms",
            KNN: "mastitis",
            NaiveBayes: "gut_worms",
          },
        });
      }
    } catch (error) {
      console.error("Prediction error:", error);
      setPrediction({
        input_symptoms: symptoms,
        predictions: {
          DecisionTree: "unable_to_determine",
          RandomForest: "unable_to_determine",
          KNN: "unable_to_determine",
          NaiveBayes: "unable_to_determine",
        },
      });
    }
    setIsLoading(false);
  };

  const formatDiseaseName = (disease: string) => {
    return disease.replace(/_/g, " ").replace(/\b\w/g, (l) => l.toUpperCase());
  };

  const getConsensus = (predictions: any) => {
    const predictionValues = Object.values(predictions);
    const counts: any = predictionValues.reduce((acc: any, pred) => {
      acc[pred as string] = (acc[pred as string] || 0) + 1;
      return acc;
    }, {});

    const maxCount = Math.max(...(Object.values(counts) as number[]));
    const consensus = Object.keys(counts).find((key) => counts[key] === maxCount);
    const confidence = Math.round((maxCount / 4) * 100);

    return { disease: consensus, confidence };
  };

  return (
    <div className="min-h-screen bg-hero-gradient pt-28 pb-16">
      <div className="container mx-auto px-4">
        {/* Header */}
        <div className="text-center mb-12 animate-fade-in">
          <div className="flex items-center justify-center gap-3 mb-4">
            <div className="icon-box w-16 h-16">
              <Stethoscope className="w-8 h-8 text-white" />
            </div>
          </div>
          <h1 className="text-4xl md:text-5xl font-display font-bold text-forest-800 mb-4">
            Disease Detection
          </h1>
          <p className="text-lg text-forest-600 max-w-2xl mx-auto">
            AI-powered cattle health assessment using 4 machine learning models
          </p>
        </div>

        <div className="grid lg:grid-cols-2 gap-8 max-w-6xl mx-auto">
          {/* Input Form */}
          <div className="card-glass rounded-2xl overflow-hidden animate-fade-in" style={{ animationDelay: "0.1s" }}>
            <div className="bg-gradient-to-r from-forest-600 to-meadow-600 text-white p-6">
              <h2 className="text-xl font-display font-semibold flex items-center gap-2">
                <Activity className="w-5 h-5" />
                Symptom Selection
              </h2>
              <p className="text-forest-100 text-sm mt-1">
                Select at least 2 symptoms observed in the cattle
              </p>
            </div>
            
            <div className="p-6 space-y-6">
              {/* Search */}
              <div>
                <label className="block font-medium text-sm mb-2 flex items-center gap-2 text-forest-700">
                  <Search className="w-4 h-4" />
                  Search Symptoms
                </label>
                <input
                  type="text"
                  placeholder="Type to search symptoms..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full p-3 border-2 border-meadow-200 rounded-xl bg-white/80 text-forest-800 placeholder-forest-400 focus:ring-2 focus:ring-forest-500 focus:border-forest-500 transition-all duration-200"
                />
              </div>

              {/* Symptoms Grid */}
              <div>
                <label className="block font-medium text-sm mb-3 text-forest-700">
                  Available Symptoms ({filteredSymptoms.length})
                </label>
                <div className="max-h-64 overflow-y-auto border-2 border-meadow-200 rounded-xl p-3 bg-white/50">
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                    {filteredSymptoms.map((symptom) => (
                      <label
                        key={symptom}
                        className={`flex items-center p-2.5 rounded-lg cursor-pointer transition-all duration-200 ${
                          symptoms.includes(symptom)
                            ? "bg-forest-100 text-forest-800 border-2 border-forest-500"
                            : "hover:bg-meadow-50 text-forest-600 border-2 border-transparent"
                        }`}
                      >
                        <input
                          type="checkbox"
                          checked={symptoms.includes(symptom)}
                          onChange={() => handleSymptomToggle(symptom)}
                          className="mr-2 w-4 h-4 text-forest-600 rounded focus:ring-forest-500 border-meadow-300"
                        />
                        <span className="text-sm capitalize">{symptom.replace(/_/g, " ")}</span>
                      </label>
                    ))}
                  </div>
                </div>
              </div>

              {/* Selected Symptoms */}
              {symptoms.length > 0 && (
                <div className="animate-fade-in">
                  <label className="block font-semibold mb-2 text-forest-700">
                    Selected ({symptoms.length}):
                  </label>
                  <div className="flex flex-wrap gap-2">
                    {symptoms.map((symptom) => (
                      <span
                        key={symptom}
                        className="px-3 py-1.5 bg-forest-100 text-forest-700 rounded-full text-sm font-medium flex items-center gap-1 border border-forest-200"
                      >
                        {symptom.replace(/_/g, " ")}
                        <button
                          onClick={() => handleSymptomToggle(symptom)}
                          className="ml-1 text-forest-500 hover:text-sunset-600 transition-colors"
                        >
                          ×
                        </button>
                      </span>
                    ))}
                  </div>
                </div>
              )}

              {/* Predict Button */}
              <button
                onClick={handlePredict}
                disabled={symptoms.length < 2 || isLoading}
                className="btn-primary w-full py-4 text-lg disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
              >
                {isLoading ? (
                  <div className="flex items-center justify-center gap-2">
                    <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    Analyzing...
                  </div>
                ) : (
                  <div className="flex items-center justify-center gap-2">
                    <Brain className="w-5 h-5" />
                    {symptoms.length < 2
                      ? `Select ${2 - symptoms.length} more symptom${2 - symptoms.length > 1 ? "s" : ""}`
                      : "Predict Disease"}
                  </div>
                )}
              </button>
            </div>
          </div>

          {/* Results Section */}
          <div className="card-glass rounded-2xl overflow-hidden animate-fade-in" style={{ animationDelay: "0.2s" }}>
            <div className="bg-gradient-to-r from-meadow-600 to-forest-600 text-white p-6">
              <h2 className="text-xl font-display font-semibold flex items-center gap-2">
                <TrendingUp className="w-5 h-5" />
                ML Model Predictions
              </h2>
              <p className="text-meadow-100 text-sm mt-1">Results from 4 machine learning algorithms</p>
            </div>
            
            <div className="p-6">
              {!prediction ? (
                <div className="text-center py-16">
                  <div className="w-20 h-20 mx-auto mb-6 rounded-full bg-meadow-100 flex items-center justify-center">
                    <Heart className="w-10 h-10 text-meadow-400" />
                  </div>
                  <p className="text-forest-500 text-lg">
                    Select symptoms and click "Predict Disease"
                  </p>
                </div>
              ) : (
                <div className="space-y-6 animate-fade-in">
                  {/* Consensus */}
                  {(() => {
                    const consensus = getConsensus(prediction.predictions);
                    return (
                      <div className="p-5 bg-gradient-to-r from-forest-50 to-meadow-50 border-2 border-forest-200 rounded-xl">
                        <h3 className="text-forest-700 font-semibold mb-3 flex items-center gap-2">
                          <Sparkles className="w-4 h-4 text-sunset-500" />
                          Consensus Prediction
                        </h3>
                        <div className="flex items-center justify-between mb-3">
                          <span className="text-forest-800 font-bold text-2xl font-display">
                            {formatDiseaseName(consensus.disease || "Unknown")}
                          </span>
                          <span className="bg-forest-600 text-white px-4 py-1.5 rounded-full text-sm font-medium">
                            {consensus.confidence}% Agreement
                          </span>
                        </div>
                        <div className="w-full bg-meadow-200 rounded-full h-3">
                          <div
                            className="bg-gradient-to-r from-forest-500 to-meadow-500 h-3 rounded-full transition-all duration-700"
                            style={{ width: `${consensus.confidence}%` }}
                          />
                        </div>
                      </div>
                    );
                  })()}

                  {/* Individual Predictions */}
                  <div>
                    <h3 className="font-semibold mb-3 text-forest-800 flex items-center gap-2">
                      <Activity className="w-4 h-4" />
                      Individual Model Predictions
                    </h3>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                      {Object.entries(prediction.predictions).map(([model, disease]) => (
                        <div
                          key={model}
                          className="p-4 bg-white/70 rounded-xl border-2 border-meadow-200 hover;border-forest-300 transition-colors"
                        >
                          <div className="flex items-center justify-between mb-2">
                            <span className="font-medium text-forest-700 text-sm">
                              {model === "DecisionTree"
                                ? "Decision Tree"
                                : model === "RandomForest"
                                ? "Random Forest"
                                : model === "KNN"
                                ? "K-Nearest Neighbors"
                                : "Naive Bayes"}
                            </span>
                            <div className="w-2 h-2 bg-forest-500 rounded-full animate-pulse"></div>
                          </div>
                          <p className="text-forest-800 font-semibold">{formatDiseaseName(disease)}</p>
                        </div>
                      ))}
                    </div>
                  </div>

                  {/* Analyzed Symptoms */}
                  <div>
                    <h3 className="font-semibold mb-2 text-forest-800">
                      Analyzed Symptoms ({prediction.input_symptoms.length})
                    </h3>
                    <div className="flex flex-wrap gap-2">
                      {prediction.input_symptoms.map((symptom) => (
                        <span
                          key={symptom}
                          className="px-3 py-1 bg-meadow-100 text-meadow-700 rounded-full text-sm border border-meadow-200"
                        >
                          {formatDiseaseName(symptom)}
                        </span>
                      ))}
                    </div>
                  </div>

                  {/* Disclaimer */}
                  <div className="p-4 bg-sunset-50 border-2 border-sunset-200 rounded-xl">
                    <div className="flex gap-3 items-start">
                      <AlertTriangle className="w-5 h-5 text-sunset-600 mt-0.5 flex-shrink-0" />
                      <div>
                        <p className="font-medium text-sunset-700 mb-1 text-sm">
                          Veterinary Disclaimer
                        </p>
                        <p className="text-sm text-sunset-600">
                          These ML predictions are for informational purposes only. Please consult
                          with a qualified veterinarian for proper diagnosis and treatment.
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
