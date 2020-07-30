from TTS.server.synthesizer import Synthesizer



MODEL_PATH = './tts_model.pth.tar'
CONFIG_PATH = './config.json'

VOCODER_MODEL_PATH = './vocoder_model.pth.tar'
VOCODER_CONFIG_PATH = './config_vocoder.json'

class Config:
    tts_checkpoint = MODEL_PATH
    tts_config = CONFIG_PATH
    use_cuda=False
    tts_speakers = None
    vocoder_checkpoint = VOCODER_MODEL_PATH
    vocoder_config = VOCODER_CONFIG_PATH
    wavernn_lib_path = None

synthesizer = Synthesizer(Config())

texts = """
Hello world, i can speak, yahoo!
"""
data = synthesizer.tts(texts)

with open("./audio_output/hello.wav","wb") as f:
    f.write(data.read())


from pysndfx import AudioEffectsChain

fx = (
    AudioEffectsChain()
    .highshelf()
    .speed(0.8)
    .pitch(-31)
    .reverb(30)
    # .chorus(0.4, 0.6, [[55, 0.4, 0.55, .5, 't']])
    .lowshelf()
)

infile = './audio_output/hello.wav'
outfile = './audio_output/hello2.wav'

# Apply phaser and reverb directly to an audio file.
fx(infile, outfile)