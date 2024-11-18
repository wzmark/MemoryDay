import router from '@ohos.router';


@Component

export struct AddImageButton{

        build() {

                Button(){
                        Image($r('app.media.plus'))
                                .width('50%')
                                .height('20%')
                                .fillColor(Color.White).clip(true).borderRadius(10)
                                .border({
                                        width: "8px",
                                        color: Color.White
                                }).padding({
                                        top: '20px',   // 设置上内边距
                                        bottom: '20px'  // 设置下内边距
                                })

                }.onClick(() => {

                }).backgroundColor('#00000000')
        }
}