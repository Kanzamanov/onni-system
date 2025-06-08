<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Onni.User.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        /* For disappearing alert message */
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%= lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Contact Section Begin (Ogani style) -->
    <section class="contact spad">
    <div class="container">
        <div class="row">
            <!-- Левая колонка: контактная информация -->
            <div class="col-lg-5 mb-4">
                <h4 class="mb-3">Контакты</h4>
                <p><strong>Адрес:</strong> ул. Бейшеналиевой, 42<br />
                ТЦ Беш-Сары, 11-R бутик, 2-этаж<br />
                <strong>Телефон:</strong> +996 702 01 75 45</p>
                <p class="mt-4">
                    Пожалуйста, если вы не нашли ответ на свой вопрос,<br />
                    задайте его через форму или напишите на email:<br />
                    <strong>onni_kgz@gmail.com</strong>
                </p>
            </div>

            <!-- Правая колонка: форма -->
            <div class="col-lg-7">
                <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="alert alert-success" />
                <div class="bg-light border rounded p-4 shadow-sm">
                    <h5 class="text-center mb-4">Если у вас есть вопросы или предложения — заполните форму ниже.</h5>
                    <div class="mb-3">
                        <asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Введите имя" ControlToValidate="txtName" ForeColor="Red" Display="Dynamic" />
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Ваше имя" />
                    </div>
                    <div class="mb-3">
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ErrorMessage="Введите email" ControlToValidate="txtEmail" ForeColor="Red" Display="Dynamic" />
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Ваш email" TextMode="Email" />
                    </div>
                    <div class="mb-3">
                        <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ErrorMessage="Введите тему" ControlToValidate="txtSubject" ForeColor="Red" Display="Dynamic" />
                        <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" placeholder="Тема сообщения" />
                    </div>
                    <div class="mb-4">
                        <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ErrorMessage="Введите сообщение" ControlToValidate="txtMessage" ForeColor="Red" Display="Dynamic" />
                        <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" placeholder="Ваше сообщение" TextMode="MultiLine" Rows="4" />
                    </div>
                    <div class="text-center">
                        <asp:Button ID="btnSubmit" runat="server" Text="Отправить" CssClass="site-btn px-5" OnClick="btnSubmit_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

    <!-- Contact Section End -->
</asp:Content>
