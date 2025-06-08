<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="Onni.Admin.Users" %>

<%@ Import Namespace="Onni" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

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

    <div class="pcoded-inner-content pt-0">
        <div class="align-align-self-end">
            <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
        </div>

        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-header">
                                </div>
                                <div class="card-block">
                                    <div class="row">
                                        <div class="col-12 mobile-inputs">
                                            <h4 class="sub-title">Список Пользователей</h4>
                                            <div class="card-block table-border-style">
                                                <div class="table-responsive">
                                                    <asp:Repeater ID="rUsers" runat="server" OnItemCommand="rUsers_ItemCommand">
                                                        <HeaderTemplate>
                                                            <table class="table data-table-export table-hover nowrap">
                                                                <thead>
                                                                    <tr>
                                                                        <th class="table-plus">№</th>
                                                                        <th>ФИО</th>
                                                                        <th>Имя пользователя</th>
                                                                        <th>Электронная почта</th>
                                                                        <th>Дата регистрации</th>
                                                                        <th>Статус</th>
                                                                        <th class="datatable-nosort">Действие</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td class="table-plus"><%# Eval("SrNo") %></td>
                                                                <td><%# Eval("Name") %></td>
                                                                <td><%# Eval("Username") %></td>
                                                                <td><%# Eval("Email") %></td>
                                                                <td><%# Eval("CreatedDate") %></td>
                                                                <td>
                                                                    <%# Convert.ToBoolean(Eval("IsBlocked")) ? "Заблокирован" : "Активен" %>
                                                                </td>
                                                                <td>
                                                                    <asp:LinkButton ID="lnkBlock" runat="server"
                                                                        CssClass='<%# Convert.ToBoolean(Eval("IsBlocked")) ? "badge bg-success" : "badge bg-warning" %>'
                                                                        ToolTip='<%# Convert.ToBoolean(Eval("IsBlocked")) ? "Разблокировать пользователя" : "Заблокировать пользователя" %>'
                                                                        CommandArgument='<%# Eval("UserId") %>' CommandName="toggleblock"
                                                                        CausesValidation="false"><i class='<%# Convert.ToBoolean(Eval("IsBlocked")) ? "fas fa-unlock" : "fas fa-user-lock" %>'></i>
                                                                    </asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </tbody>
                                                         </table>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
