#! /usr/bin/env python

import sys, getopt, os, shutil


# Usage:
#
# Generate specific atlas
# python pack_and_compress -a ATLAS_NAME
#
# Generate all atlases
# python pack_and_compress
#
# Generate all atlases and compress to atf
# python pack_and_compress -c
#



assetsFolderPath = "/Users/hyh/Desktop/g3_assets"
pngFolderPath = assetsFolderPath + "/png"
texturesFolderPath = assetsFolderPath + "/textures"

shoeboxPath = "/Applications/ShoeBox.app/Contents/MacOS/ShoeBox"
png2atfPath = "/Applications/Adobe\ Gaming\ SDK\ 1.4/Utilities/ATF\ Tools/png2atf"
texturePackerPath = "/usr/local/bin/TexturePacker"

use_shoebox = False


should_compress_atf = False

scale = 0.5

def main(argv):

    makeAll = False;

    atlasName = ''
    try:
        opts, args = getopt.getopt(argv, "a:Ac:s:", ["atlas=", "all=", "compress=", "scale="])
    except getopt.GetoptError:
        print 'PackAndCompress.py -a <atlas> | -A [-c]'
        sys.exit()
    for opt, arg in opts:
        if opt in ("-a", "--atlas"):
            atlasName = arg
        elif opt in ("-c", "--compress"):
            global should_compress_atf
            should_compress_atf = True if arg == "True" else arg == "False"
            print type(should_compress_atf), should_compress_atf
        elif opt in ("-A", "--all"):
            makeAll = True
        elif opt in ("-s", "--scale"):
            global scale
            scale = arg

    

    if atlasName != '':
        print "Making atlas %s" % atlasName
        if os.path.exists(pngFolderPath + "/" + atlasName):
            folder = pngFolderPath + "/" + atlasName
        else:
            print("Can't find folder %s" % atlasName)
            exit(1);

        makeAtlas(folder, atlasName)
        print "Completed."
    elif makeAll:
        print "Making all atlasses..."

        atlasNames = [x[1] for x in os.walk(folder)][0]
        for atlasName in atlasNames:
            makeAtlas(pngFolderPath + "/" + atlasName, atlasName)

        print "Completed."
    else:
        print 'PackAndCompress.py -a <atlas> | -A [-c]'



def findAndMoveFile(atlasFolderPath, atlasName):

    if not os.path.exists(pngFolderPath + "/atlas"):
        os.mkdir(pngFolderPath + "/atlas")

    atlasPath = atlasFolderPath + "/" + atlasName

    if os.path.exists(atlasPath + ".xml"):
        src = atlasPath + ".xml"
        dst = pngFolderPath + "/atlas/" + atlasName + ".xml"
        dst2 = texturesFolderPath + "/" + atlasName + ".xml"
        if os.path.exists(dst):
            os.remove(dst)
        os.rename(src, dst)

        if os.path.exists(dst2):
            os.remove(dst2)
        shutil.copy(dst, dst2)

        src = atlasPath + ".png"
        dst = pngFolderPath + "/atlas/" + atlasName + ".png"
        dst2 = texturesFolderPath + "/" + atlasName + ".png"
        if os.path.exists(dst):
            os.remove(dst)
        os.rename(src, dst)

        if os.path.exists(dst2):
            os.remove(dst2)
        shutil.copy(dst, dst2)

    else:
        dirnames = [x[1] for x in os.walk(atlasFolderPath)][0]
        for dirname in dirnames:
            findAndMoveFile(atlasFolderPath + "/" + dirname, atlasName)

def compress(atlasName):
    if os.path.exists(texturesFolderPath + "/" + atlasName + ".png"):
        os.system(png2atfPath + " -r -n 0,0 -q 30 -i " + texturesFolderPath + "/" + atlasName + ".png -o " + texturesFolderPath + "/" + atlasName + ".atf")
        src = texturesFolderPath + "/" + atlasName + ".png"
        if (os.path.exists(src)):
            os.remove(src)
    else:
        print "png " + atlasName + ".png did not exist in directory " + texturesFolderPath + "/"

def removeAtf(atlasName):
    src = texturesFolderPath + "/" + atlasName + ".atf"
    if (os.path.exists(src)):
        os.remove(src)



def packWithShoeBox(folder, atlasName):

    texMaxSize = "2048"

    command = ''
    command += '%s "plugin=shoebox.plugin.spriteSheet::PluginCreateSpriteSheet"' % shoeboxPath
    command += ' "files=%s" "texSquare=false" "texExtrudeSize=0"' % folder
    command += ' "texMaxSize=%s" "texPowerOfTwo=%s" "scale=0.5"' % (texMaxSize, "true" if should_compress_atf else "false")
    command += ' fileName=%s.xml' % atlasName
    command += ' "fileFormatOuter=<TextureAtlas imagePath=\\"%s.png\\">\\n@loop</TextureAtlas>"' % atlasName
    command += ' "fileFormatLoop=\\t<SubTexture name=\\"@ID\\" x=\\"@x\\" y=\\"@y\\" width=\\"@w\\" height=\\"@h\\"/>\\n"'
    print(command)
    os.system(command)


def packWithTexturePacker(folder, atlasName):
    
    texMaxSize = "2048"

    command = ''
    command += '%s ' % texturePackerPath
    command += ' --max-size %s' % texMaxSize
    command += ' --replace .*/='
    command += ' --size-constraints %s --format sparrow %s --scale %s' % ("POT" if should_compress_atf else "AnySize", folder, scale)
    command += ' --data %s.xml --sheet %s.png' % (folder + "/" + atlasName, folder + "/" + atlasName)
    #command += ' --trim-mode None'
    print(command)
    os.system(command)
    pass



def makeAtlas(folder, atlasName):

    if use_shoebox:
        packWithShoeBox(folder, atlasName)
    else:
        packWithTexturePacker(folder, atlasName)

    findAndMoveFile(folder, atlasName)
    if should_compress_atf:
        compress(atlasName)
    else:
        removeAtf(atlasName)

if __name__ == "__main__":
    main(sys.argv[1:])
