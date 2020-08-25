library(ggplot2)

weather <- read.csv("weather.csv")

ggplot(weather, aes(season, fill = dir_wind)) +
  geom_bar(position = "dodge") 

p_weather <- ggplot(weather, aes(season, fill = dir_wind)) +
  geom_bar(position = "dodge") + 
  scale_fill_manual(values =  c("red","blue", "yellow", "green"))

p_weather

p_weather  + theme(legend.position = c(0.12, 0.88)) 

mytheme <- theme_bw() +
  theme(legend.position = c(0.93, 0.85)) +		# �趨ͼ��λ��
  theme(axis.text = element_text(size = 10)) +    	# �趨����̶ȱ�ʾ�ֺ�
  theme(axis.title = element_text(size = 12)) +	# �趨����������ֺ�
  theme(panel.grid = element_blank()) 		# �ѱ���������ȥ��

p_weather + mytheme
