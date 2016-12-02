#!/bin/bash -e
# clear
train_slice=$1

###########################
# SETUP (edit these paths)
#
# word embeddings
WORD_EMBEDDINGS_BIN="DATA/embeddings/embs_emoji_2_400"
#
###########################

###########################
# OPTIONS
#
# number of paralel jobs
N_WORKERS=17
# number of negative samples
negative_samples=10
#
###########################

### You shouldn't need to change these commands ###
# aux_data is a pickle generated when building the training data and
# contains wrd2idx,unigram distribution,E
aux_data="DATA/tmp/aux.pkl"
train_data_path="DATA/tmp/train_data"${train_slice}".pkl"


########### ACTION!
printf "\n##### Estimate Context Conditional Probabilities #####\n"
THEANO_FLAGS="device=cpu" python code/context_probs.py -input ${train_data_path} \
													   -aux_data ${aux_data} \
													   -emb ${WORD_EMBEDDINGS_BIN} \
													   -n_workers ${N_WORKERS}
printf "\n##### Get Negative Samples #####\n"
# 
THEANO_FLAGS="device=cpu" python code/negative_samples.py -input ${train_data_path} \
														  -aux_data ${aux_data} \
														  -negative_samples ${negative_samples} \
														  -n_workers ${N_WORKERS}