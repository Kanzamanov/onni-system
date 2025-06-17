<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Onni.User.Login" %>

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
    <!-- Login Form Begin -->
    <div class="contact-form spad">
        <div class="container">
            <div class="heading_container">
                <div class="contact__form__title text-right">
                    <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="text-danger d-block mt-2" />
                </div>
                <div class="contact__form__title text-center">
                    <asp:Label ID="lblHeaderMsg" runat="server" Text="Авторизация Пользователя" CssClass="h2" />
                </div>
            </div>
            <div class="row justify-content-center">
                <div class="col-lg-4">
                    <div class="bg-light border rounded shadow p-4">
                        <!-- Картинка-иконка -->
                        <div class="text-center mb-3">
                            <img src="../Images/login.png" class="img-thumbnail rounded-circle" style="width: 110px; height: 110px;" />
                        </div>

                        <!-- Username -->
                        <div class="mb-3">
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ErrorMessage="Требуется логин"
                                ControlToValidate="txtUsername" ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revUsername" runat="server" ControlToValidate="txtUsername"
                                ValidationExpression="^[a-zA-Z0-9_]{3,20}$" ErrorMessage="Логин должен состоять из латинских символов"
                                ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Логин"
                                ToolTip="Username"></asp:TextBox>
                        </div>

                        <!-- Password -->
                        <div class="mb-3">
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ErrorMessage="Требуется пароль"
                                ControlToValidate="txtPassword" ForeColor="Red" Display="Dynamic" SetFocusOnError="true">
                            </asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Пароль"
                                ToolTip="Password" TextMode="Password"></asp:TextBox>
                        </div>

                        <!-- Login Button -->
                        <div class="text-center mt-4">
                            <asp:Button ID="btnLogin" runat="server" Text="Войти" CssClass="site-btn"
                                OnClick="btnLogin_Click" />
                        </div>

                        <!-- Already Login -->
                        <div class="text-center mt-2">
                            <asp:Label ID="lblAlreadyUser" runat="server"
                                Text="Не зарегистрированы? <a href='Registration.aspx' class='badge badge-info'>Создать аккаунт</a>" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
