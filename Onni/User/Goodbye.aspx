<%@ Page Title="Аккаунт деактивирован"
         Language="C#"
         MasterPageFile="~/User/User.Master"
         AutoEventWireup="true" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <!-- никаких доп. стилей не требуется: берём из темы -->
</asp:Content>

<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Хлебная крошка (Ogani) ------------------------------------- -->
    <section class="breadcrumb-section set-bg"
             data-setbg="img/breadcrumb.jpg"><!-- замените на свой фон -->
        <div class="container">
            <div class="row">
                <div class="col-lg-12 text-center">
                    <div class="breadcrumb__text">
                        <h2>Аккаунт деактивирован</h2>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Сообщение --------------------------------------------------- -->
    <section class="checkout spad">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="shadow p-5 text-center checkout__order">
                        <h3 class="text-danger mb-3">
                            <i class="fa fa-user-slash mr-2"></i>
                            Ваш аккаунт отключён
                        </h3>
                        <p class="mb-4">
                            История покупок сохранена.<br />
                            Если захотите восстановить доступ — напишите в&nbsp;нашу поддержку.
                        </p>

                        <a href="Catalog.aspx" class="site-btn">
                            Вернуться в магазин
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
