import router from '@ohos.router';


@Component

export struct AddEventButton{

    build() {

        Button(){
            Image($r('app.media.plus'))
                .width('10%')
                .height('5%')
                .fillColor(Color.White)

        }.onClick(() => {
            router.pushUrl({
                url: "pages/Add"
            }, router.RouterMode.Standard)
            console.log("jump")
        }).backgroundColor('#00000000')
    }
}