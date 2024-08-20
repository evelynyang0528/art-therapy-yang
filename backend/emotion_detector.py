from fer import FER, Video
import pandas as pd


def get_emotion(video_path):
 print("==============Starting=====================")
#  build the face detection
 face_detector =FER(mtcnn=True)

 # extract the video
 input_video=Video(video_file=video_path)

    # analyze the video with face detector
 print("==============Analyzing=====================")
 analyzed_data = input_video.analyze(
  face_detector,
  display=False,
  save_video=False,
  save_frames=False,
 ) 
 # converts analyze information to dataframes
 video_data_frame = input_video.to_pandas(analyzed_data) 
 video_data_frame = input_video.get_first_face(video_data_frame)
 video_data_frame = input_video.get_emotions(video_data_frame)

# extracting the emotions from the dataframes
 angry=sum(video_data_frame.angry)
 disgust=sum(video_data_frame.disgust)
 fear=sum(video_data_frame.fear)
 happy=sum(video_data_frame.happy)
 sad=sum(video_data_frame.sad)
 surprise=sum(video_data_frame.surprise)
 neutral=sum(video_data_frame.neutral)
 # create the list of emotions
 list_of_emotions = ["Angry","Disgust","Fear","Happy","Sad","Surprise","Neutral"]
 list_of_emotion_values = [angry,disgust,fear,happy,sad,surprise,neutral]
 

 # get the maximum value
 scores_comparison = pd.DataFrame(list_of_emotions,columns=["Human Emotions"])
 scores_comparison["Emotion Value from the Video"] = list_of_emotion_values
 max_rows = scores_comparison[
   scores_comparison["Emotion Value from the Video"] == scores_comparison["Emotion Value from the Video"].max()
 ]
 print("=======================================Max Row=====")
 print(max_rows) 
 emotion = max_rows["Human Emotions"].values[0]
 return emotion

 
