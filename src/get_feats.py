'''
This script generates the feature vectors for the data using the list of selected features 
listed in the files: "./selected_features/feats_*.csv".

'''
crime_types=['Murder (Incidence)', 'Attempt to Commit Murder (Incidence)', 'Burglary  (Incidence)', 'Auto Theft (Incidence)', 'Incidence of Crimes Committed Against Women Rape (Incidence)', 'Incidence of Crimes Committed Against Women Kidnapping & Abduction (Incidence)', 'Incidence of Crimes Committed Against Women Dowry Death (Incidence)', 'Incidence of Crimes Committed Against Women Cruelty By Husband & Relatives (Incidence)', 'Incidence of Crimes Committed Against Women Molestation (Incidence)', 'Incidence of Crimes Committed Against Women Total (Incidence)']

crimes={}
for crime in crime_types:
     crimes[crime]=True

data={}
atts=[] #stores the attributes of the districts
with open('../competition_data/crime_training_data.csv') as f:
     for line in f.readlines()[1:]:
	  district,att,value=line.strip().split(',')	  
	  district=district.strip()
	  att=att.strip()
	  value=value.strip()
	  #removing bangalore city
	  if district != 'Bangalore City':
		  if district not in data:
			   data[district]={}
		  
		  if att not in data[district]:     
				data[district][att]=value
				
		  if att not in atts and att not in crimes:
				atts.append(att)
	
with open('../competition_data/socio_economic_training_data.csv') as f:
     for line in f.readlines()[1:]:
	  district,att,value=line.strip().split(',')
	  district=district.strip()
	  att=att.strip()
	  value=value.strip()
	  #removing bangalore city
	  if district != 'Bangalore City':
		  if att not in data[district]:     
				data[district][att]=value	  
		  if att not in atts and att not in crimes:
			   atts.append(att)

#removing attributes that arent present for all cities
to_remove=[]
for att in atts:
	 for district in data:
	    if att not in data[district]:
		  to_remove.append(att)
		  break
for i in xrange(len(to_remove)):
	att=to_remove[i]
	atts.remove(att)

	
#creating the training data files
for i in xrange(len(crime_types)):
	put={}
	with open('../selected_features/feats_'+str(i+1)+'.csv') as f:
		for line in f.readlines():
			put[line.strip()]=True
	with open('../feature_vectors/feats_'+str(i+1)+'.csv','w') as f:
		for district in data:
			s=""
			for att in atts:
				if att in put:
					s=s+data[district][att] + ","
			crime_type=crime_types[i]
			if crime_type in data[district]:
				f.write( s+data[district][crime_type]+"\n")

				
#creating the testing data files
dists=[]
d={}
id_map={}
i=1
with open('../competition_data/id_map.csv') as f:
     for line in f.readlines()[1:]:
		id1,district,crime=line.strip().split(',')
		if district not in d:
			id_map[district]={}
			d[district]=True
			dists.append(district)
		id_map[district][crime]=i
		i=i+1

for i in xrange(len(crime_types)):
	put={}
	with open('../selected_features/feats_'+str(i+1)+'.csv') as f:
		for line in f.readlines():
			put[line.strip()]=True
			
	with open('../feature_vectors/feats_'+str(i+1)+'_test.csv','w') as f:
		for district in dists:
			 s=""
			 for att in atts:
				if att in put:
					s=s+data[district][att] + ","
			 f.write(s+str(id_map[district][crime_types[i]])+"\n")